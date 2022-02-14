class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :plan_type
      t.float :price
      t.string :cycle
      t.text :features

      t.timestamps
    end
  end
end
