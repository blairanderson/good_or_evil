class BrandsController < ApplicationController
  def show
    @brands = Brand.top_list.limit(50)
    @brand = Brand.friendly.find(params[:id])
    @items = @brand.items
  end

end
