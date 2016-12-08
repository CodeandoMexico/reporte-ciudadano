class Organisation < ActiveRecord::Base
  validates :name,
            presence: true
end
