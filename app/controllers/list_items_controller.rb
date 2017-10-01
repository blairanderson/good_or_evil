class ListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_list_item, only: [:destroy]

  def create
    @list.list_items.create!(list_item_params)
    redirect_to edit_list_path(@list)
  end

  def destroy
    @list_item.destroy
    redirect_to edit_list_path(@list)
  end


  private
  def set_list
    @list = current_user.lists.includes(:items).find(params[:list_id])
  end

  def set_list_item
    @list_item = @list.list_items.where(item_id: params[:id]).first!
  end

  def list_item_params
    params.require(:list_item).permit(:item_id)
  end
end
