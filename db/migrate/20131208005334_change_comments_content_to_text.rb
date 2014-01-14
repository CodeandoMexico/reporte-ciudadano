class ChangeCommentsContentToText < ActiveRecord::Migration
  def change
    change_column :comments, :content, :text, default: ""
  end
end
