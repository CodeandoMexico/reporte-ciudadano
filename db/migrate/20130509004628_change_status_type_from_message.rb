class ChangeStatusTypeFromMessage < ActiveRecord::Migration

  def up
    change_column :messages, :status, :string
  end

  def down
    connection.execute(%q{
    alter table messages 
    alter column status 
    type integer using cast(status as integer)
                       })
  end
end
