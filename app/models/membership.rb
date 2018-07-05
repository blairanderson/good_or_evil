class Membership < ActiveRecord::Base
  belongs_to :account
  belongs_to :user
  belongs_to :created_by, polymorphic: true

  scope :accepted, -> { where(accepted_by_user: true) }
  scope :pending, -> { where(accepted_by_user: false) }

  PENDING_LIMIT = 5
end
