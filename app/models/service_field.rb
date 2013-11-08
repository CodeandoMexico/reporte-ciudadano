class ServiceField < ActiveRecord::Base
  attr_accessible :service_id, :name

  belongs_to :service

  def to_s
    self.name
  end

end
