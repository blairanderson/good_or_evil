class MenusController < UserController
  def index
    if current_account.site_menus.count == 0
      first = current_account.site_menus.create!
      first.location = :header
      first.save!
      first.site_menu_links.create!(name: "HOME", link: "/")
    end
    @menus = current_account.site_menus.includes(:site_menu_links).order('site_menu_links.position')
  end

  def edit
  end

  def new
    @menu = current_account.site_menus.build
  end


  def create
    @menu = current_account.site_menus.create(valid_params)

    if @menu.valid?
      redirect_to edit_account_menu_path(current_account, @menu)
    else
      flash[:alert] = @account.errors.full_messages.join(", ")
      render :new
    end
  end

  private
  def valid_params
    params.require(:menu).permit(:location)
  end

end
