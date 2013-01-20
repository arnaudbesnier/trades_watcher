class CreateTransactionTable < ActiveRecord::Migration
  def up
    create_table :transactions do |t|
      t.integer :type
      t.decimal :amount
      t.date    :created_at
  	end
  end

  def down
  	drop_table :transactions
  end
end
