class BoostListsController < ApplicationController
  before_action :set_list, only: [:edit, :update, :destroy]

  def index
    @lists = List.bootstrap
    @suggestions = %w[
women mom
men dad
elderly
college
geeks geek
dogs dog
cats cat
babies baby
cooks
chefs
nurses
teachers
doctors
accountants
      ]

    # elsif params[:bootstrap_id].to_i > 0
    # redirect_to new_lists_items_path(params[:bootstrap_id]) and return
  end

  def create
    before = List.bootstrap.count
    Array(params[:words]).each_with_index do |name, index|
      List.transaction do
        list = List.bootstrap.where(name: name)
                 .first_or_create!(name: name, body: "#{name} " * 10)
        list.update!(sort: index + 1, source: "https://www.amazon.com/s?field-keywords=#{name.split(" ").join("+")}")
        list.increment!(:page_views)
      end
    end
    render json: {before: before, after: List.bootstrap.count, status: 200}
  end

  def edit
    @list_items = @list.list_items.order("LENGTH(details) DESC").includes(:item, item: :brand)
  end

  def update
    list_item_id = Base64.decode64(params[:secure_key].strip)
    unless list_item_id == params[:list_item_id] && list_item_id == params.dig(:list_item, :id)
      flash[:alert] = "GTFO"
      redirect_to root_path and return
    end

    list_item = @list.list_items.find(list_item_id)

    if list_item.update!(list_item_params.slice(:details))
      flash[:notice] = "Updated!"
    else
      flash[:alert] = list_item.errors.full_messages.join(", ")
    end
    redirect_to edit_boost_list_path(@list)
  end

  private
  def set_list
    @list = List.bootstrap.find(params[:id])
  end

  def list_item_params
    params.require(:list_item).permit(:id, :details)
  end
end
