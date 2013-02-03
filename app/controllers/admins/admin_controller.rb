class Admins::AdminController < ApplicationController
  before_filter :authenticate_admin!
  layout 'admins'
end
