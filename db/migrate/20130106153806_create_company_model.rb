class CreateActionModel < ActiveRecord::Migration
  def up
  	create_table :companies do |t|
  		t.string :name
  		t.string :symbol
  	end

  	add_column :trades, :company_id, :integer
  end

  def down
  	remove_column :trades, :company_id
  	drop_table :companies
  end
end
