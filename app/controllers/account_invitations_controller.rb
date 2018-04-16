class AccountInvitationsController < UserController

  def index
    @invitations = AccountInvitation.where(email: current_user.email).includes(:user, :account)
  end

  # TODO make this safer?
  # acc = Account.find(valid_params[:account_id])
  # request.referer.contains?(acc.slug)
  def create
    invitation = current_user.account_invitations.where(valid_params).first_or_initialize
    if invitation.save
      flash[:notice] = "Success: Invited #{valid_params[:email]}"
    else
      flash[:alert] = invitation.errors.full_messages.join(", ")
    end
    redirect_to edit_account_path(valid_params[:account_id])
  end


  def destroy
    invitation = AccountInvitation.find(params[:id])
    account = invitation.account

    if invitation.user_id == current_user.id || invitation.email == current_user.email
      invitation.destroy
    end
    redirect_to edit_account_path(account.id)
  end


  private
  def valid_params
    params.require(:account_invitation).permit(:email, :account_id)
  end

end
