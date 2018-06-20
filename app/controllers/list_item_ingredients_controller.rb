class ListItemIngredientsController < UserController
  def create
    if ListItem.exists?(id: valid_params[:list_item_id], user_id: current_user.id)
      item = ListItem.find(valid_params[:list_item_id])
      list = item.list
      ingredient = ListItemIngredient.create(valid_params)
      flash[:notice] = "Added: #{ingredient.name}"
    else
      flash[:alert] = "NOPE!"
    end

    redirect_to edit_account_list_path(list.account, list, anchor: item.id)
  end


  def update
    ingredient = ListItemIngredient.find(params[:id])
    item = ingredient.list_item
    list = item.list

    if list.account_id.in?(current_accounts.map(&:id)) && ingredient.update(valid_params)
      flash[:notice] = "Updated: #{ingredient.name}"
    else
      flash[:alert] = "NOPE!"
    end

    redirect_to edit_account_list_path(list.account, list, anchor: item.id)
  end

  private
  def valid_params
    params.require(:list_item_ingredient).permit(
      :name,
      :list_item_id,
      :quantity,
      :unit_cd,
      :unit,
      :comment
    )
  end

end
