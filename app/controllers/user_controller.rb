class UserController < ApplicationController
  before_filter :require_user
  before_filter :find_accounts

  helper_method :current_accounts, :account_count

  def require_user
    redirect_to new_user_registration_path and return unless current_user
  end

  def find_accounts
    @account_count ||= current_user.accounts.count
    @accounts ||= current_user.accounts
  end

  def current_accounts
    @accounts ||= find_accounts
  end

  def account_count
    @account_count ||= current_user.accounts.count
  end
end
