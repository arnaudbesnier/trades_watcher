class CreateDividendTable < ActiveRecord::Migration
  def up
    create_table :dividends do |t|
      t.integer :company_id
      t.integer :shares
      t.date    :received_at
      t.decimal :amount
      t.decimal :taxes
    end
  end

  def down
    drop_table :dividends
  end
end