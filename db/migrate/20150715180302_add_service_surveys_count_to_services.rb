class AddServiceSurveysCountToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :service_surveys_count, :integer, default: 0

    Service.reset_column_information
    Service.find_each do |s|
      Service.update_counters s.id, service_surveys_count: s.service_surveys.length
    end
  end

  def self.down
    remove_column :services, :service_surveys_count
  end
end
