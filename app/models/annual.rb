class Annual

  attr_reader :year, :deposits, :trade_gains, :dividends, :closings,
  			      :deposits_total, :trade_gains_total, :dividends_total,
              :trade_gains_performance, :dividends_performance 

  def initialize year
  	@year                  = year
  	@year_current_datetime = Time.new(@year)
  	@year_next_datetime    = Time.new(@year + 1)

    begin_year = Time.new(2011)

    @deposits       = Transaction.deposit_total(@year_current_datetime, @year_next_datetime)
    @deposits_total = Transaction.deposit_total(begin_year, @year_next_datetime)

    @dividends       = Dividend.total_net(@year_current_datetime, @year_next_datetime)
    @dividends_total = Dividend.total_net(begin_year, @year_next_datetime)

    @trade_gains, @trade_gains_total = 0, 0
  	trade_gains_year  = Trade.joins('LEFT OUTER JOIN orders ON orders.id = trades.order_close_id').where('orders.executed_at > ? AND orders.executed_at < ?', @year_current_datetime, @year_next_datetime)
  	trade_gains_total = Trade.joins('LEFT OUTER JOIN orders ON orders.id = trades.order_close_id').where('orders.executed_at < ?', @year_next_datetime)
  	@closings         = trade_gains_year.count
    trade_gains_year.each  { |trade| @trade_gains       += trade.gain }
    trade_gains_total.each { |trade| @trade_gains_total += trade.gain }
 
    @trade_gains_performance = @trade_gains / @deposits_total * 100
    @dividends_performance   = @dividends / @deposits_total * 100
  end

  def valorization
  	@deposits_total + @dividends_total + @trade_gains_total
  end

  def gain_year
    @dividends + @trade_gains
  end

  def gain_total
    @dividends_total + @trade_gains_total
  end

  def performance_year
    gain_year / @deposits_total * 100    
  end

  def performance_total
    gain_total / @deposits_total * 100
  end

end
