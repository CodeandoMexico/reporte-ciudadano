class RenameCategoryReferencesToService < ActiveRecord::Migration
  def change
    rename_column :messages, :category_id, :service_id
    rename_column :service_fields, :category_id, :service_id
    rename_column :service_requests, :category_id, :service_id
    rename_column :service_requests, :category_fields, :service_fields

    rename_index :messages, 'index_messages_on_category_id', 'index_messages_on_service_id'
    rename_index :service_requests, 'index_service_requests_on_category_id', 'index_service_requests_on_service_id'
  end
end
