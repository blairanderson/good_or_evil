module Lists
  class ItemsController < UserController
    include SetList
    helper_method :current_list
    before_filter :set_item, only: [:update, :destroy]

    def create
      item = current_list.list_items.where(user_id: current_user.id).where(item_params).create!
      should_save = false

      if item.amazon? && item.fetch_asin != item.asin
        should_save = true
        item.asin = item.fetch_asin
      end

      if !item.image && item.amazon?
        # AUTOMATICALLY FETCH AMAZON IMAGE IF THE LINK INCLUDES AN ASIN
        should_save = true
        item.image = open(item.asin_image(item.fetch_asin))
      end

      item.save if should_save
      redirect_to edit_account_list_path(current_account, current_list, anchor: item.id, autofocus: item.id)
    end

    def update
      @list_item.update!(item_params)
      redirect_to edit_account_list_path(current_account, current_list, anchor: @list_item.id, autofocus: @list_item.id)
    end

    def sort
      Array.wrap(params[:list_item]).each_with_index do |id, index|
        ListItem.where(id: id).update_all(sort: index + 1)
      end

      render json: {list_item: Array.wrap(params[:list_item])}
    end

    def destroy
      @list_item.list_item_ingredients.delete_all
      @list_item.destroy!
      redirect_to edit_account_list_path(current_account, current_list)
    end

    private

    def set_item
      @list_item = current_list.list_items.find(params[:id])
    end

    def item_params
      params.require(:list_item).permit(
        :title,
        :affiliate_link,
        :body,
        :image,
        :style,
        :style_cd,
        :rating
      )
    end

  end
end
