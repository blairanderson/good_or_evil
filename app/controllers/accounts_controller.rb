class AccountsController < UserController
  def index
    if account_count == 0
      redirect_to new_account_path
    elsif account_count == 1
      redirect_to account_path(current_accounts.first)
    end
  end

  def edit
    @lists = current_account.lists.published
    @drafts = current_account.lists.drafts
  end

  def show
    redirect_to(edit_account_path(Account.friendly.find(params[:id])))
  end

  def new
    @account = Account.new(name: params.dig(:account,:name))
  end


  def create
    @account = current_user.accounts.build(valid_params)

    if @account.save
      redirect_to account_path(@account)
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

    redirect_to account_path(current_account)
  end


  private
  def valid_params
    params.require(:account).permit(:name, :host)
  end

end
