class Message < ActiveRecord::Base
  attr_accessible :content, :status

  belongs_to :category
end
