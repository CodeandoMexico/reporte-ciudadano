class Office < ActiveRecord::Base
  validates :name,
            presence: true
end
