class Organisation < ActiveRecord::Base
  has_many :admins

  validates :name,
            presence: true
end
