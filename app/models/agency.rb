class Agency < ActiveRecord::Base
  has_many :admins

  validates :name,
            presence: true
end
