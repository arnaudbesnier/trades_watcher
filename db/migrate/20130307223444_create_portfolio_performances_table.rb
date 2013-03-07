class CreatePortfolioPerformancesTable < ActiveRecord::Migration
  def up
  	create_table :portfolio_performances do |t|
  	  t.integer   :period_type_id
  	  t.timestamp :time_close
  	  t.decimal   :value_close
  	  t.decimal   :value_open
  	  t.timestamps
  	end
  end

  def down
  	drop_table :portfolio_performances
  end
end
