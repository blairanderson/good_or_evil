module Lists
  class ItemsController < UserController
    include SetList
    helper_method :current_list
    before_filter :set_item, only: [:update, :destroy]

    def create
      binding.pry
      @list_item = current_list.list_items.where(user_id: current_user.id).first_or_create!

      if @list_item.persisted?
        # verify an item exists for this list_item
        flash[:notice] = "Great Job! Now tell us why its a great gift?"
      else
        flash[:error] = @list_item.errors.full_messages.join(", ")
      end

      redirect_to edit_account_list_path(current_list)
    end

    def update
      @list_item.update!(item_params)
      redirect_to new_list_item_path(current_list)
    end

    def destroy
      @list_item.destroy!
      redirect_to new_list_item_path(current_list)
    end

    private

    def set_item
      @list_item = current_list.list_items.find(params[:id])
    end

    def item_params
      params.require(:list_item).permit(:url, :details)
    end

  end
end
