class RenameCategoryToService < ActiveRecord::Migration
  def change
    rename_table :categories, :services
    rename_table :category_fields, :service_fields
  end
end
