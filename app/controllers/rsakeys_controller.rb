class RsakeyController < ApplicationController
  def new
    public = File.read('~/.ssh/id_rsa.pub')
    render :json => { "publickey" => public }.as_json
  end
end