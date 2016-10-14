class ServiceReport < ActiveRecord::Base
  belongs_to :service
  serialize :overall_areas, Hash

  scope :with_cis_id, ->(cis_id){ where(cis_id: cis_id).order(created_at: :asc) }
end
