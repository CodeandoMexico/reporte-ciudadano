class Organisation < ActiveRecord::Base
  has_many :services
  has_many :service_requests, through: :services
  has_many :admins
  has_many :agencies, dependent: :destroy

  validates :name,
            presence: true
end
