class AddDefaultValuesToLlLgTpReports < ActiveRecord::Migration
  def self.up
    change_column_default :reports, :lat, "-96.724253"
    change_column_default :reports, :lng, "17.065593"
  end

  def self.down
    change_column_default :reports, :lat, ""
    change_column_default :reports, :lng, ""
  end
end
