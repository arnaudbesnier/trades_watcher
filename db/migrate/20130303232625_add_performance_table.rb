class AddPerformanceTable < ActiveRecord::Migration
  def up
  	create_table :performances do |t|
  	  t.integer    :company_id
  	  t.integer    :period_type_id
  	  t.timestamp  :time_close
  	  t.decimal    :value_close
  	  t.decimal    :value_open
  	  t.decimal    :value_high
  	  t.decimal    :value_low
  	  t.timestamps
  	end

  	Company.all.each do |company|
  	  company_quotes = company.quotes.where('created_at > ?', Date.new(2013, 02, 11))
  	  							     .order('created_at ASC')
  	  puts " ==> #{company.name} -> #{company_quotes.count} quotes"


  	  timestamp_first_day = company_quotes.first.created_at
  	  timestamp_last_day  = company_quotes.last.created_at

  	  first_day = Date.new(timestamp_first_day.year, timestamp_first_day.month, timestamp_first_day.day)
  	  last_day  = Date.new(timestamp_last_day.year, timestamp_last_day.month, timestamp_last_day.day)

  	  (first_day..last_day).each do |day|
  	  	quote = company.quotes.where('created_at < ?', day + 1)
  	  				   .order('created_at DESC').first
  	  	performance = CompanyPerformance.create({
  	  	  :company_id     => company.id,
  	  	  :period_type_id => CompanyPerformance::PERIOD_DAY,
  	  	  :time_close     => quote.created_at,
  	  	  :value_open     => quote.value_day_open,
  	  	  :value_close    => quote.value,
  	  	  :value_high     => quote.value_day_high,
  	  	  :value_low      => quote.value_day_low
  	  	})
  	  	puts "   ==> performance created for day: #{performance.time_close}"
  	  end
  	end

  end

  def down
  	drop_table :performances
  end
end