module Services
  def self.service_type_options
    (I18n.t("service_type_options").values).zip [:service, :step, :support_program]
  end

  def self.service_dependency_options
    load_values(:dependencies).fetch("dependencies").values
  end

  def self.service_administrative_unit_options
    load_values(:administrative_units).fetch("administrative_units").values
  end

  def self.service_cis_options
    load_values(:cis).fetch("cis").values
  end

  def self.is_assigned_to_public_servant?(service, public_servant)
    public_servant.services.include?(service)
  end

  private

  def self.load_values(object)
    File.open(path_to(object)) { |file| YAML.load(file.read) }
  end

  def self.path_to(object)
    File.expand_path("#{object}.yml", File.dirname(__FILE__))
  end
end