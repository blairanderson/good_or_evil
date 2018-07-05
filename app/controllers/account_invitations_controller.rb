class AccountInvitationsController < UserController

  def index
    @invitations = current_user.memberships.pending.includes(:account, :created_by)
    @memberships = current_user.memberships.accepted.includes(:account, :created_by)
  end

  # TODO make this safer?
  # acc = Account.find(valid_params[:account_id])
  # request.referer.contains?(acc.slug)
  def create
    if current_user.pending_invitation_count > Membership::PENDING_LIMIT
      flash[:alert] = "You have sent too many pending invitations already"
      redirect_to edit_account_path(valid_params[:account_id], anchor: :invitations, active: :invitations)
    end

    user = User.invite!(valid_params.slice(:email), current_user)
    if user.valid?
      Membership.where(user_id: user.id, account_id: valid_params[:account_id]).first_or_create!(created_by: current_user)
      flash[:notice] = "Invitation sent to <strong>#{valid_params[:email].truncate(30)}</strong>"
    else
      flash[:notice] = "<strong>#{valid_params[:email].truncate(30)}</strong> IS A WACK EMAIL<br>Could not send the invite!"
    end
    redirect_to edit_account_path(valid_params[:account_id], anchor: :invitations, active: :invitations)
  end

  def update
    # this is to accept an invitation
    unless can_accept_membership?
      flash[:alert] = "You cannot accept this invitation"
      redirect_to root_path and return
    end

    current_membership.update_attribute(:accepted_by_user, true)
    flash[:notice] = "Woo Hoo"
    redirect_to account_path(current_membership.account_id)
  end

  def destroy
    # this is to accept an invitation
    unless can_destroy_membership?
      flash[:alert] = "You cannot accept this invitation"
      redirect_to root_path and return
    end

    redirect_to edit_account_path(account.id)
  end


  private
  def valid_params
    params.require(:account_invitation).permit(:email, :account_id)
  end

  def current_membership
    @current_membership ||= Membership.find(params[:id])
  end

  def can_destroy_membership?
    current_user.id.in?([
        current_membership.user_id,
        current_membership.created_by_id
      ])
  end

  def can_accept_membership?
    current_membership.user_id == current_user.id
  end

end
