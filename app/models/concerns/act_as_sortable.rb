require 'active_support/concern'

module ActAsSortable
  extend ActiveSupport::Concern

  included do

    scope :by_position, -> { order(:position) }
    scope :by_position_reversed, -> { order('position DESC')}

    before_create do
      last = self.class.order('position DESC').first
      last_position = last.try(:position) || 0
      self.position = last_position + 1
    end

  end

end
