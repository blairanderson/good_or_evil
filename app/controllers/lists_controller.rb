class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  include SetList
  helper_method :current_list

  def index
    list_scope = List.visible.includes(items: :brand).where("items.title IS NOT NULL").references(:items)
    if params[:user_id] && user = User.find_by_id(params[:user_id])
      list_scope = list_scope.where("lists.user_id = ? OR list_items.user_id = ?", user.id, user.id)
    end
    @lists = list_scope.paginate(page: params[:page], per_page: 25)

    @items = Item.order("page_views DESC").limit(25).includes(:list_items)
  end

  def show
    @list = List.visible.find(params[:id])
    @list_items = @list.list_items.order("items.title IS NOT NULL DESC, sort ASC").includes(:item)
    session[:historical_list_ids] = (Array(session[:historical_list_ids]).unshift(@list.id)).flatten.uniq.slice(0, 10)
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
    @list_items = current_list.list_items.includes(:item, item: :brand)
    @can_change_display_theme = @list_items.length > 0 && @list_items.none? { |li| li.details.blank? }
  end

  def update
    if current_list.update(list_params)
      flash[:notice] = "Updated!"
    else
      flash[:alert] = current_list.errors.full_messages.join(", ")
    end
    current_list.reload
    redirect_to(current_list.published? ? list_path(current_list) : new_list_item_path(current_list))
  end

  def destroy
    current_list.destroy
    redirect_to root_path
  end

  private
  def set_list
    current_list
  end

  def list_params
    params.require(:list).permit(:name, :body, :item_id, :category_id, :status, :display_theme)
  end
end
