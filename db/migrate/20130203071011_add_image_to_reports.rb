class AddImageToReports < ActiveRecord::Migration
  def change
    add_column :reports, :image, :string
  end
end
