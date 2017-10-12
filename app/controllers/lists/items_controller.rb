module Lists
  class ItemsController < ApplicationController
    before_action :authenticate_user!
    helper_method :current_list
    before_filter :current_list
    before_filter :set_item, only: [:fetch, :update, :destroy]

    def new
      @list_item = current_list.list_items.build
      @list_items = current_list.list_items.includes(:item, item: :brand)
      if missing_item = @list_items.find { |list_item| list_item.item.blank? }
        redirect_to fetch_list_item_path(current_list, missing_item) and return
      end
      params[:query] ||= current_list.name
      @search_items = can_bootstrap? ? AmazonFetch.query(params[:query]) : []
    end

    def fetch
      if @list_item.is_amazon?
        fetch = AmazonFetch.fetch(@list_item.asin).with_indifferent_access
        item = OpenStruct.new(persisted?: false)

        Item.transaction do
          brand = Brand.where(name: fetch[:brand]).first_or_create
          new_state = fetch.slice(:title, :description, :buy_now, :total_offers, :sales_rank, :dimensions, :package_dimensions, :buy_box, :images)
          new_state[:price_cents] = new_state.dig(:buy_box, :winning, :Amount).to_i
          item = Item.where(fetch.slice(:asin)).first_or_create!(new_state)
          item.update!(new_state.merge(brand_id: brand.id))
        end

        if @list_item.update({item_id: item.id})
          flash[:notice] = "WOOHOO!!!"
          redirect_to new_list_item_path(current_list) and return
        else
          flash[:notice] = @list_item.errors.full_messages.join(", ")
          if @list_item.errors && ListItem::UNIQUE_MESSAGE.in?(Array(@list_item.errors[:item_id]))
            @list_item.destroy
          end
          redirect_to new_list_item_path(current_list) and return
        end
      else
        flash[:notice] = "#{@list_item.source_domain} is not yet supported."
      end
    end

    def create
      Item.transaction do
        @item = Item.where_url(params.require(:item).permit(:url).dig(:url)).first_or_create! do |i|
          i.sync!
        end
        @list_item = @list.list_items.where(item_id: @item.id).first_or_create!
      end

      if @item.persisted? && @list_item.persisted?
        # verify an item exists for this list_item
        flash[:notice] = "Great Job! Now tell us why its a great gift?"
      else
        flash[:error] = [@item, @list_item].map(&:errors).flatten.map(&:full_messages).flatten.join(", ")
      end

      redirect_to new_list_item_path(current_list)
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

    def can_bootstrap?
      is_admin? || is_robot?
    end

    def current_list
      @list ||= (can_bootstrap? ? List : current_user.lists).find(params[:list_id])
    end

    def set_item
      @list_item = current_list.list_items.find(params[:id])
    end

    def item_params
      params.require(:list_item).permit(:url, :details)
    end

  end
end
