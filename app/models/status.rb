class Status < ActiveRecord::Base
  attr_accessible :name
  has_many :reports
  has_many :messages

  validates :name, presence: true

  default_scope order('created_at')

  def to_s
    name
  end
end
