class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_list, only: [:edit, :update, :destroy]

  def index
    @lists = List.published.includes(items: :brand).where.not(items: {id: nil})
  end

  def bootstrap
    if request.post? && current_user
      Array(params[:words]).each_with_index do |name, index|
        List.transaction do
          list = List.draft.where(user_id: nil, name: name).first_or_create!(name: name, body: name * 10)
          list.update!(sort: index+1)
          list.increment!(:page_views)
        end
      end
      render json: {count: current_user.lists.draft.count, status: 200} and return

    else
      @lists = List.draft.where(user_id: nil).order("sort ASC")
    end
  end

  def show
    @list = List.published.includes(:category, :user).find(params[:id])
    @list_items = @list.list_items.order("sort ASC").includes(:item)
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
      @list = List.draft.where(name: nil).first_or_create
      session[:list_id] = @list.id
    end
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
