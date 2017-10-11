class SavedItemsController < ApplicationController
  def index
    @items = Item.where(id: current_user.saved_items.pluck(:item_id))
  end

  def create
    item = Item.find(params.dig(:item, :id))
    if current_user.saved_items.where(item_id: item.id).first_or_create!
      flash[:notice] = "added to your <a href='#{saved_items_path}'>Saved Items</a>.".html_safe
    end
    redirect_to :back
  end

  def destroy
    current_user.saved_items.where(item_id: params[:id]).destroy_all
    flash[:notice] = "Removed from your <a href='#{saved_items_path}'>Saved Items</a>.".html_safe
    redirect_to :back
  end

  private

  def saved_item_params
    params.require(:saved_item).permit(:item_id)
  end
end
