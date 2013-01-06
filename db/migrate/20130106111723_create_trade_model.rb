class CreateTradeModel < ActiveRecord::Migration
  def up
  	create_table :trades do |t|
  		t.decimal   :price_bought
  		t.decimal   :price_sold
  		t.integer   :shares
  		t.timestamp :opened_at
  		t.timestamp :closed_at
  		t.decimal   :commission_total
  		t.decimal   :taxes
  		t.timestamps
  	end
  end

  def down
  	drop_table :trades
  end
end
