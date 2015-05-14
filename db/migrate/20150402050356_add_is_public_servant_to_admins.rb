class AddIsPublicServantToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :is_public_servant, :boolean
  end
end
