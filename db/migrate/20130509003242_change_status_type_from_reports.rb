class ChangeStatusTypeFromReports < ActiveRecord::Migration
  def up
    change_column :reports, :status, :string
  end

  def down
    connection.execute(%q{
    alter table reports 
    alter column status 
    type integer using cast(status as integer)
                       })
  end
end
