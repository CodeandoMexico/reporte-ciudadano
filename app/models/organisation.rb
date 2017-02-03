class Organisation < ActiveRecord::Base
  has_many :admins
  has_many :agencies, dependent: :destroy

  validates :name,
            presence: true
end
