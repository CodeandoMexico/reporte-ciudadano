class RenameReportsToServiceRequests < ActiveRecord::Migration
  def change
    rename_table :reports, :service_requests

    # Rename indexes
    rename_index :service_requests, "index_reports_on_category_id", "index_service_requests_on_category_id"
    rename_index :service_requests, "index_reports_on_reportable_id_and_reportable_type", "index_service_requests_on_reportable_id_and_reportable_type"
    rename_index :service_requests, "index_reports_on_status_id", "index_service_requests_on_status_id"
  end
end
