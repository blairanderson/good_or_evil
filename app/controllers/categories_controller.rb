class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @lists = @category.lists.includes(:item)
  end
end
