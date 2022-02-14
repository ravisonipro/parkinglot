class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.string :transaction_id
      t.string :amount
      t.string :status

      t.timestamps
    end
  end
end
