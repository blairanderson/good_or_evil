class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_list, only: [:edit, :update, :destroy]

  def index
    @lists = List.visible.includes(items: :brand).where("items.title IS NOT NULL").references(:items).paginate(page: params[:page], per_page: 25)
    @items = Item.order("page_views DESC").limit(25).includes(:list_items)
  end

  def show
    @list = List.visible.find(params[:id])
    @list_items = @list.list_items.order("items.title IS NOT NULL DESC, sort ASC").includes(:item)
    session[:historical_list_ids] = (Array(session[:historical_list_ids]).unshift(@list.id)).flatten.uniq.slice(0,10)
  end

  def preview
    @list = current_user.lists.includes(:category, :user).find(params[:id])
    @list_items = @list.list_items.order("sort ASC").includes(:item)
  end

  def new
    @list = false
    @drafts = []
    @published = []
    if current_user
      @list = current_user.lists.draft.where(name: nil).first_or_create
      @drafts = current_user.lists.draft.where.not(name: nil)
      @published = current_user.lists.published
    else
      @list = if session[:list_id]
                List.bootstrap.find(session[:list_id])
              end
    end
    @count = List.count

    @bootstrap = (is_admin? || is_robot?) ? List.bootstrap.amazon.sorted : []
  end

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      redirect_to new_list_item_path(@list)
    else
      render 'new'
    end
  end

  def edit
    @list_items = @list.list_items.includes(:item, item: :brand)
  end

  def update
    if @list.update(list_params)
      flash[:notice] = "Updated!"
    else
      flash[:alert] = @list.errors.full_messages.join(", ")
    end
    @list.reload
    redirect_to(@list.published? ? list_path(@list) : new_list_item_path(@list))
  end

  def destroy
    @list.destroy
    redirect_to root_path
  end

  private
  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :body, :item_id, :category_id, :status, :display_theme)
  end
end
