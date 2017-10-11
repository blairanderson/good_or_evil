class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :lists
  has_many :saved_items

  def saved_item_ids
    @saved_item_ids ||= saved_items.pluck(:item_id)
  end
end
