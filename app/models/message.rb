class Message < ActiveRecord::Base
  attr_accessible :content, :status

  belongs_to :category

  scope :with_status, lambda { |status|
    where(status: status)
  }
end
