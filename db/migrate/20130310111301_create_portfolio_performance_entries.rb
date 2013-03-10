class CreatePortfolioPerformanceEntries < ActiveRecord::Migration
  def up
  	rename_column :portfolio_performances, :time_close, :closed_at
  	add_column    :portfolio_performances, :closings, :integer
  	add_column    :portfolio_performances, :trade_gains, :decimal

  	PortfolioPerformance.reset_column_information

  	# Populate PortfolioPerformance table with day performance
  	timestamp_first_day = Quote.order('created_at ASC').limit(1).first.created_at
  	timestamp_last_day  = Quote.order('created_at DESC').limit(1).first.created_at

  	first_day = Date.new(timestamp_first_day.year, timestamp_first_day.month, timestamp_first_day.day)
  	last_day  = Date.new(timestamp_last_day.year, timestamp_last_day.month, timestamp_last_day.day)

  	(first_day..last_day).each do |today|
  	  puts " == populate performance day : #{today}"
  	  tomorrow = today + 1.day

  	  performance                = PortfolioPerformance.new
  	  performance.period_type_id = PortfolioPerformance::PERIOD_DAY
  	  performance.closed_at      = Time.new(today.year, today.month, today.day, 19)

      trades = Trade.joins("INNER JOIN orders orders_open ON orders_open.id = trades.order_open_id AND orders_open.executed_at < date '#{tomorrow}'")# +
      					           #"INNER JOIN orders orders_close ON orders_close.id = trades.order_close_id AND (orders_close.executed_at IS NULL OR orders_close.executed_at > date '#{today}')")

      puts " == trades count: #{trades.count}"
      performance.closings    = trades.inject(0) { |sum, trade| sum += 1          if trade.order_close && trade.order_close.executed_at > today && trade.order_close.executed_at < tomorrow }
      performance.trade_gains = trades.inject(0) { |sum, trade| sum += trade.gain if trade.order_close && trade.order_close.executed_at > today && trade.order_close.executed_at < tomorrow } 

      value_open, value_close = 0, 0

      trades.each do |trade|
        puts " == trade on company: #{trade.company.name}"

	  	  if trade.order_close.nil? || trade.order_close.executed_at > tomorrow
	  	    trade_value_open  = trade.company.quotes.where('created_at > ?', today).order('created_at ASC').limit(1).first
	  	    trade_value_close = trade.company.quotes.where('created_at < ?', tomorrow).order('created_at DESC').limit(1).first

	  	    value_open  += trade.shares * trade_value_open.value  if trade_value_open
	  	    value_close += trade.shares * trade_value_close.value if trade_value_close
	  	  end
	    end

	    performance.value_open  = value_open
	    performance.value_close = value_close
	    performance.save!
  	end
  end

  def down
  	PortfolioPerformance.delete_all
  	rename_column :portfolio_performances, :closed_at, :time_close
  	remove_column :portfolio_performances, :closings
  	remove_column :portfolio_performances, :trade_gains
  end
end
