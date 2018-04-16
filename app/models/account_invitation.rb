class AccountInvitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  validates_presence_of :email

  validate :email_is_not_same_as_account_holders

  def email_is_not_same_as_account_holders
    errors.add(:email, "BAD! Cannot invite yourself...") if email == user.email
  end
end

