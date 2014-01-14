class ServiceField < ActiveRecord::Base
  attr_accessible :service_id, :name

  belongs_to :service
  validates :name, presence: true

  def to_s
    self.name
  end

end
