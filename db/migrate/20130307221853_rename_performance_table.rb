class RenamePerformanceTable < ActiveRecord::Migration
  def up
  	rename_table :performances, :company_performances
  end

  def down
  	rename_table :company_performances, :performances
  end
end
