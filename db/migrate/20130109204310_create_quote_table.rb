class CreateQuoteTable < ActiveRecord::Migration
  def up
  	create_table :quotes do |t|
  		t.integer :company_id
  		t.decimal :value
  		t.decimal :value_day_open
  		t.decimal :value_day_low
  		t.decimal :value_day_high
  		t.decimal :variation_day_low
  		t.decimal :variation_day_high
  		t.decimal :variation_day_current
  		t.integer :volume
  		t.timestamp :created_at
  	end
  end

  def down
  	drop_table :quotes
  end
end
