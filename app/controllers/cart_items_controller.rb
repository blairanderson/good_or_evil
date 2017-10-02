class CartItemsController < ApplicationController

  def index
    @items = Item.where(asin: current_cart.keys.uniq)
  end

  def create
    session[:cart][params[:id]] = params[:quantity]
    redirect_to :back
  end

  def update
    qty = params[:quantity].to_i
    if qty < 1
      session[:cart] = session[:cart].except(params[:id])
      flash[:notice]= "Item removed"
    else
      session[:cart][params[:id]] = qty
      flash[:notice] = "Quantity updated to #{qty}"
    end

    redirect_to :back
  end

  def destroy
    if session[:cart].has_key?(params[:id])
      session[:cart] = session[:cart].except(params[:id])
    end

    redirect_to :back
  end

end
