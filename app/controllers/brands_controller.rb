class BrandsController < ApplicationController
  def show
    @brand = Brand.friendly.find(params[:id])
  end

end
