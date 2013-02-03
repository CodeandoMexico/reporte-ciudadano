class CategoriesController < ApplicationController
  def load_category_fields
    @category = Category.find(params[:id]) 
    @category_fields = @category.category_fields
  end
end
