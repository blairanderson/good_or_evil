class ListsController < UserController
  before_action :authenticate_user!, except: [:index, :show]
  include SetList
  helper_method :current_list

  def index
    @lists = List.visible.includes(items: :brand).where("items.title IS NOT NULL").references(:items).paginate(page: params[:page], per_page: 25)
  end

  def show
    @list = List.visible.find(params[:id])
    @list.increment!(:page_views)
    @list_items = @list.list_items.order("items.title IS NOT NULL DESC, sort ASC").includes(:item)
  end

  def preview
    @list = current_account.lists.includes(:category, :user).friendly.find(params[:id])
    @list_items = @list.list_items.order("sort ASC").includes(:item)
    render layout: "site_preview", template: "sites/show"
  end

  def new
    @list = current_account.lists.draft.for_user(current_user).where(name: nil).first_or_create
    @drafts = current_account.lists.draft.for_user(current_user).where.not(name: nil)
    @published = current_account.lists.published
  end

  def create
    @list = current_account.lists.build(list_params)
    if @list.save
      redirect_to new_list_item_path(@list)
    else
      render 'new'
    end
  end

  def edit
    @list_items = current_list.list_items
  end

  def update
    if current_list.update(list_params)
      flash[:notice] = "Updated!"
    else
      flash[:alert] = current_list.errors.full_messages.join(", ")
    end

    redirect_to edit_account_list_path(current_account, current_list)
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
