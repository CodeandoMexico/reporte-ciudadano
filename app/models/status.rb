class Status < ActiveRecord::Base
  attr_accessible :name
  has_many :service_requests
  has_many :messages

  validates :name, presence: true

  default_scope order('created_at')

  def to_s
    name
  end
end
