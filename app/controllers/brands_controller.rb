class BrandsController < ApplicationController
  def show
    @brand = Brand.friendly.find(params[:id])
    @items = @brand.items
  end

end
