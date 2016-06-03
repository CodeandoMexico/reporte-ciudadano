class AddColumnSurnameAdmin < ActiveRecord::Migration
  def up
    add_column :admins, :surname, :text
    add_column :admins, :second_surname, :text
  end

  def down
    remove_column :admins, :surname, :text
    remove_column :admins, :second_surname, :text
  end
end