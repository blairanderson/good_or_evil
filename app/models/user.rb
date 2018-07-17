class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :invitable

  has_many :accounts
  has_many :lists
  has_many :list_items
  has_many :saved_items
  has_many :memberships
  has_many :invited_accounts, -> { where(memberships: {accepted_by_user: false}) }, through: :memberships, source: :account
  has_many :joined_accounts, -> { where(memberships: {accepted_by_user: true}) }, through: :memberships, source: :account
  has_many :pending_invitation_members, -> { where(memberships: {accepted_by_user: false}) }, through: :memberships, source: :user


  # ALLOWING USERS TO SIGN UP WITHOUT EMAIL
  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  def pending_invitation_count
    @pending_invitation_count ||= User.where(invited_by_id: id, invitation_accepted_at: nil).count
  end

  def has_invitations_left?
    pending_invitation_count < Membership::PENDING_LIMIT
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  def password_required?
    super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
end
