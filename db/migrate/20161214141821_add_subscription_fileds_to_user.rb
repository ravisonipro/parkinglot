class AddSubscriptionFiledsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subscription_id, :integer
    add_column :users, :subscription_start_date, :date
    add_column :users, :subscription_end_date, :date
    add_column :users, :subscribed, :boolean, default: false
  end
end
