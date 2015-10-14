module RegistrationsHelper
  def load_secret
    OpenSSL::PKey::RSA.new File.read("#{ENV['SSL_SECRET']}")
  end

  def get_encrypted_data(data)
    require 'base64'
    load_secret.private_decrypt Base64.strict_decode64(data)
  end

  def get_aes_data(data, password)
    require 'digest'
    require 'base64'

    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    salt = OpenSSL::Random.pseudo_bytes(8)

    salted = ''
    dx = ''

    while salted.length < 48
      md5 = Digest::MD5.new
      md5.update dx + password + salt
      dx = md5.digest
      salted += dx
    end

    key = salted.slice(0, 32)
    iv = salted.slice(32, 16)

    cipher.key = key
    cipher.iv = iv

    encrypted_data = cipher.update(data) + cipher.final
    Base64.strict_encode64('Salted__' + salt + encrypted_data)
  end

  def get_raw_data(edata, password)
    require 'digest'
    require 'base64'

    data = Base64::strict_decode64(edata)
    salt = data.slice(8, 8)
    body = data[16..-1]

    round = 3
    data00 = password + salt
    md5_hash = []
    result = md5_hash[0] = Digest::MD5.new.digest data00

    (1..2).each do | step |
      md5_hash[step] = Digest::MD5.new.digest (md5_hash[step - 1] + data00)
      result += md5_hash[step]
    end

    key = result.slice(0, 32)
    iv = result.slice(32, 16)

    decipher = OpenSSL::Cipher.new('aes-256-cbc')
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv

    decipher.update(body) + decipher.final
  end

  def build_params
    if params["jCryption"] or (ENV["SSL_SECRET"] != nil and ENV["SSL_PUBLIC"] != nil)
      begin
        data = get_raw_data(params["jCryption"], session[:session_base])
        session.delete :session_base
      rescue
        # error ocacionado por la cache del navegador
        session.delete :session_base
        flash[:notice] = "Algo fue mal, por favor refresca la pagina"
        return
      end



      creds = Rack::Utils.parse_nested_query(data)
      if creds.has_key? "user"
        params["user"] = creds["user"]
        h = creds["user"]
        role = :user
      elsif creds.has_key? "admin"
        role = :admin
        params["admin"] = creds["admin"]
        h = creds["admin"]
      end
      params["email"] = h["email"]
      params["password"] = h["password"]
      params["remember_me"] = h["remember_me"]
      params["utf8"] = creds["utf8"]
      params["commit"] = creds["commit"]
      params.delete(:jCryption)

      env["action_dispatch.request.request_parameters"] = { role => {
          :password => h["password"],
          :email => h["email"],
          :remember_me => h["remember_me"]
      }}
      env["action_dispatch.request.request_parameters"].delete(:jCryption)

      env["action_dispatch.request.parameters"] = { role => {
          :password => h["password"],
          :email => h["email"],
          :remember_me => h["remember_me"]
      }}
      env["action_dispatch.request.parameters"].delete(:jCryption)
=begin
      # env["rack.request.form_hash"] = { :user => creds["user"] }
      env["rack.request.form_hash"].delete(:jCryption)

      # env["rack.request.form_vars"]
      env["rack.request.form_vars"] = { :user => creds["user"] }

      env["rack.request.form_vars"].delete(:jCryption)

      Rack::Request.new(env).update_param(:user, creds["user"])
=end


    end
  end
end
