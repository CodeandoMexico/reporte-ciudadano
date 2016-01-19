module Services
  def self.service_type_options
    (I18n.t("service_type_options").values).zip [:service, :step, :support_program]
  end

  def self.service_dependency_options
     t1 = Time.now
    a = load_values(:dependencies).fetch("dependencies").values
  end

  def self.service_administrative_unit_options
   load_values(:administrative_units).fetch("administrative_units").values
  end

  def self.service_name_options
    Service.pluck(:name)
  end

  def self.service_cis_options
    load_values(:cis).map do |cis|
      { id: cis[:id], label: "#{cis[:name]} - #{cis[:address]}" }
    end
  end

  def self.service_cis
    load_values(:cis)
  end

  def self.service_reports
    load_values(:reports).map do |cis|
      { id: cis[:id], label: cis[:name] }
    end
  end

  def self.service_cis_label(cis_id)
    return "" unless cis_id.present?
    service_cis_options.select { |cis| cis[:id].to_s == cis_id }.first[:label]
  end

  def self.is_assigned_to_public_servant?(service, public_servant)
    public_servant.services.include?(service)
  end

  def self.is_assigned_to_cis?(service, cis_id)
    service.cis.include? cis_id.to_s
  end

  def self.service_admins_name_options
    Admin.
      service_admins_sorted_by_name
      .pluck(:id, :name, :surname, :second_surname)
  end

  def self.record_number_options
    Admin.
      service_admins_sorted_by_name
      .pluck(:record_number)
  end

  def self.public_servants_name_options(admin)
    Admins.
      public_servants_for(admin)
      .pluck(:id, :name, :surname, :second_surname)
  end

  def self.generate_homoclave_for(service)
    time = Time.new
    "#{type_of_service(service.service_type.to_s)}#{service.dependency.to_s[0]}#{service.administrative_unit.to_s[0] }#{time.strftime("%Y%m%d%H%M%S")}"
  end

  private

  def self.load_values(object)
  Rails.cache.fetch("#{object}-service-cache", :expires_in => 6.hours) do
      File.open(path_to(object)) { |file|

        YAML.load(file.read)

      }
    end
  end

  def self.path_to(object)
    File.expand_path("#{object}.yml", File.dirname(__FILE__))
  end

  def self.type_of_service(type)
    {
      support_program: "PA", service: "S", step: "T"
    }.fetch(type.to_sym, "F")
  end
end