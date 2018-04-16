class UserController < ApplicationController
  before_filter :find_accounts
  before_filter :require_user

  helper_method :current_account, :current_accounts, :accounts_count

  def require_user
    redirect_to new_user_registration_path and return unless current_user

    if current_account && !current_account.id.in?(current_accounts.map(&:id))
      flash[:alert] = "YOU DO NOT HAVE ACCESS TO THIS SITE..."
      redirect_to root_path and return
    end
  end

  def find_accounts
    @accounts_count ||= accounts_count
    @accounts ||= current_accounts
  end


  def current_account
    @account ||= Account.friendly.find(params[:account_id] || params[:id]) rescue nil
  end


  def current_accounts
    @accounts ||= [
      current_user.accounts.order(page_views: :desc).to_a,
      current_user.joined_accounts.order(page_views: :desc).to_a,
    ].flatten rescue []
  end

  def accounts_count
    @accounts_count ||= current_accounts.size
  end
end
