class AddValueLastToPerformances < ActiveRecord::Migration
  def change
  	add_column    :performances, :value_last, :decimal
  	rename_column :performances, :time_close, :closed_at

  	Performance.all.each do |performance|
  	  today      = performance.closed_at.to_date
  	  perf_last  = performance.company.performances.where('closed_at > ? AND closed_at < ?', today - 1.day, today).first
  	  value_last = perf_last ? perf_last.value_close : nil
  	  performance.update_attribute :value_last, value_last
  	end
  end
end
