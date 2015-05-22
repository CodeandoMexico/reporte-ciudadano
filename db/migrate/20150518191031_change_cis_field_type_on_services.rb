class ChangeCisFieldTypeOnServices < ActiveRecord::Migration
  def change
    change_column :services, :cis, :text
  end
end
