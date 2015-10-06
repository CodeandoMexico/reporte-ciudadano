class RsakeysController < ApplicationController

  def show
    public = File.read("#{ENV['SSL_PUBLIC']}")
    render :json => { "publickey" => public.rstrip }.as_json
  end

end