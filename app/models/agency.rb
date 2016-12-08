class Agency < ActiveRecord::Base
  validates :name,
            presence: true
end
