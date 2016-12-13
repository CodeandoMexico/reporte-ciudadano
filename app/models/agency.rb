class Agency < ActiveRecord::Base
  belongs_to :organisation
  has_many :admins

  validates :name,
            presence: true
end
