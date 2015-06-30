class CisReport < ActiveRecord::Base
  def self.last_report_for(cis_id)
    where(cis_id: cis_id).order(created_at: :desc).first
  end
end
