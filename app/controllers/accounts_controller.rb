class AccountsController < UserController
  def index
    if AccountInvitation.where(email: current_user.email, invitation_accepted_at: nil).count > 0
      redirect_to(account_invitations_path) and return
    end

    if accounts_count == 0
      redirect_to new_account_path
    elsif accounts_count == 1
      redirect_to account_path(current_accounts.first)
    end
  end

  def edit
  end

  def show
    lists = current_account.lists.where.not(id: nil)

    @query = params[:q].to_s.strip

    all_types = ["draft", "published"]
    view_param = params[:status].to_s
    params[:status] = if view_param.present? && view_param.in?(all_types)
                        view_param
                      else
                        "draft"
                      end

    lists = lists.where("lists.status = ?", List.statuses[params[:status]])
    lists = lists.search_for(@query) if @query.length > 0
    @lists = lists.includes(:user).paginate(per_page: 25, page: params[:list_page])
  end

  def new
    @account = Account.new(name: params.dig(:account, :name))
  end


  def create
    @account = current_user.accounts.build(valid_params)

    if @account.save
      redirect_to edit_account_path(@account)
    else
      flash[:alert] = @account.errors.full_messages.join(", ")
      render :new
    end
  end


  def update
    if current_account.update(valid_params)
      flash[:notice] = "Good Job!"
    else
      flash[:alert] = current_account.errors.full_messages.join(", ")
    end

    redirect_to edit_account_path(current_account)
  end


  private
  def valid_params
    params.require(:account).permit(
      :name,
      :host,
      :header_image,
      :header_font,
      :header_subtitle,
      :header_subtitle_font,
      :google_tag_manager,
      :list_affiliate_disclosure
    )
  end

end
