class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer  :company_id
      t.integer  :shares
      t.decimal  :price
      t.integer  :order_type
      t.decimal  :commission
      t.decimal  :taxes
      t.datetime :created_at
      t.boolean  :executed
      t.datetime :executed_at
    end
  end
end
