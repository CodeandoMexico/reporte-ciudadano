class Status < ActiveRecord::Base
  attr_accessible :name
  has_many :reports

  def to_s
    name
  end
end
