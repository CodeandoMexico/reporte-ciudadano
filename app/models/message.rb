class Message < ActiveRecord::Base
  attr_accessible :content, :status_id

  belongs_to :service
  belongs_to :status

  scope :with_status, lambda { |status_id|
    where(status_id: status_id)
  }
end
