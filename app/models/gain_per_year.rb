class GainPerYear

  attr_reader :year, :deposits, :trade_gains, :dividends,
  			  :deposits_total, :trade_gains_total, :dividends_total

  def initialize year
  	@year                  = year
  	@year_current_datetime = Time.new(@year)
  	@year_next_datetime    = Time.new(@year + 1)

  	dividendes_year  = Dividend.where('received_at > ? AND received_at < ?', @year_current_datetime, @year_next_datetime)
  	trade_gains_year = Trade.joins('LEFT OUTER JOIN orders ON orders.id = trades.order_close_id').where('orders.executed_at > ? AND orders.executed_at < ?', @year_current_datetime, @year_next_datetime)
  	deposits_year    = Transaction.where('created_at > ? AND created_at < ?', @year_current_datetime, @year_next_datetime)

  	dividendes_total  = Dividend.where('received_at < ?', @year_next_datetime)
  	trade_gains_total = Trade.joins('LEFT OUTER JOIN orders ON orders.id = trades.order_close_id').where('orders.executed_at < ?', @year_next_datetime)
  	deposits_total    = Transaction.where('created_at < ?', @year_next_datetime)

  	@dividends, @trade_gains, @deposits                   = 0, 0, 0
  	@dividends_total, @trade_gains_total, @deposits_total = 0, 0, 0

  	dividendes_year.each  { |dividend| @dividends   += dividend.total_net }
  	trade_gains_year.each { |trade|    @trade_gains += trade.gain }
  	deposits_year.each    { |deposit|  @deposits    += deposit.amount }

  	dividendes_total.each  { |dividend| @dividends_total   += dividend.total_net }
  	trade_gains_total.each { |trade|    @trade_gains_total += trade.gain }
  	deposits_total.each    { |deposit|  @deposits_total    += deposit.amount }
  end

  def value
  	@deposits_total + @dividends_total + @trade_gains_total
  end

  def performance_year
    (@dividends + @trade_gains) / @deposits_total * 100    
  end

  def performance_total
    (@dividends_total + @trade_gains_total) / @deposits_total * 100
  end

end
