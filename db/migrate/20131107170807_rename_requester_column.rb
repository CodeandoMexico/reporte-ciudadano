class RenameRequesterColumn < ActiveRecord::Migration
  def change
    # Changing column names
    rename_column :service_requests, :reportable_type, :requester_type
    rename_column :service_requests, :reportable_id, :requester_id
    rename_column :comments, :report_id, :service_request_id

    # Renaming indexes
    rename_index :comments, 'index_comments_on_report_id', 'index_comments_on_service_request_id'
    rename_index :service_requests, 'index_service_requests_on_reportable_id_and_reportable_type', 'index_service_requests_on_request_id_and_requester_type'
  end
end
