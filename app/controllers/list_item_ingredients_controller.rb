class ListItemIngredientsController < UserController
  def create
    # if user has access to this list_id
    binding.pry
    # ListItemIngredient.create(valid_params)
    # send_back_to_list

    # @account = current_user.accounts.build(valid_params)

    # if @account.save
    #   redirect_to edit_account_path(@account)
    # else
    #   flash[:alert] = @account.errors.full_messages.join(", ")
    #   render :new
    # end
  end


  def update
    if current_account.update(valid_params)
      flash[:notice] = "Good Job!"
    else
      flash[:alert] = current_account.errors.full_messages.join(", ")
    end

    redirect_to edit_account_path(current_account)
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
