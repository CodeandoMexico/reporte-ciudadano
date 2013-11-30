class Admins::ApplicationSettingsController < ApplicationController
  respond_to :json

  def css_theme
    update_setting ApplicationSettings::CssTheme
    respond_with(:admins, @setting)
  end

  def map_constraints
    update_setting ApplicationSettings::MapConstraints
    respond_with(:admins, @setting)
  end

  private

  def update_setting(klass)
    @setting = klass.get
    @setting.update_attributes(params[:setting])
  end

end
