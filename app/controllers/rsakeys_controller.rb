class RsakeysController < ApplicationController
  include RegistrationsHelper

  def show
    public = File.read("#{ENV['SSL_PUBLIC']}")
    render :json => { "publickey" => public.rstrip }.as_json
  end

  def create
    data = get_encrypted_data(params["key"])
    render :json => { "challenge" =>  get_aes_data(data, data).rstrip}
  end

end