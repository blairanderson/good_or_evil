class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :new]
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    @lists = List.published.includes(items: :brand).where.not(items: {id: nil})
  end

  def show
    @list = current_user.lists.includes(:category, :user).find(params[:id])
    @list_items = @list.list_items.order("order ASC").includes(:items)
  end

  def preview
    @list = current_user.lists.includes(:category, :user).find(params[:id])
    @list_items = @list.list_items.order("order ASC").includes(:items)
  end

  def new
    @list = false
    @drafts = @published = []
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
    @list.update(list_params)
    redirect_to new_list_item_path(@list)
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
    params.require(:list).permit(:name, :body, :item_id, :category_id)
  end
end
