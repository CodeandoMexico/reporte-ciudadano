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
end