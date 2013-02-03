class CategoryField < ActiveRecord::Base
  attr_accessible :category_id, :name

  belongs_to :category

  def to_s
    self.name
  end

end
