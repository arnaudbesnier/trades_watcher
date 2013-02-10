class SimplifyTradeTable < ActiveRecord::Migration
  def up
  	remove_column :trades, :opened_at
  	remove_column :trades, :closed_at
  	remove_column :trades, :price_bought
  	remove_column :trades, :price_sold
  	remove_column :trades, :commission_total
  	remove_column :trades, :taxes
  	add_column    :trades, :order_open_id, :integer
  	add_column    :trades, :order_close_id, :integer
  end

  def down
  end
end
