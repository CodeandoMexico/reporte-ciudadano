class ServiceReport < ActiveRecord::Base
  belongs_to :service
  serialize :overall_areas, Hash
end
