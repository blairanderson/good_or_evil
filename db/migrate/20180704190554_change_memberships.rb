class ChangeMemberships < ActiveRecord::Migration
  def up
    change_table :memberships do |t|
      t.boolean :accepted_by_user, default: false, null: false
      t.references :created_by, polymorphic: true
    end
  end

  def down
    change_table :memberships do |t|
      t.remove_references :created_by, polymorphic: true
      t.remove :accepted_by_user
    end
  end
end
