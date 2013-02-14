class Performance

  attr_reader :deposits, :dividends_net, :closings, :trade_gains,
              :stock_value, :liquidity, :valorization,
              :performance_period, :performance_total 

  def initialize begin_date=Time.new(2011), end_date=Time.now
    begin_story, now = Time.new(2011), Time.now
    period_size      = end_date - begin_date

    @deposits      = Transaction.deposit_total(begin_date, end_date)
    @dividends_net = Dividend.total_net(begin_story, end_date)
    @closings      = Trade.closed_between(begin_date, end_date).count
    @trade_gains   = Trade.sold_stock_gain(begin_date, end_date)
    @stock_value   = Trade.stock_value(end_date)

    @deposits_total    = Transaction.deposit_total(begin_story, end_date)
    @trade_gains_total = Trade.sold_stock_gain(begin_story, end_date)
    @liquidity         = @deposits_total + @dividends_net + @trade_gains_total - Trade.stock_purchase_value#(end_date)

    @valorization       = @stock_value + @liquidity
    @performance_period = @stock_value - Trade.stock_value(end_date - period_size)
    @performance_total  = @valorization - @deposits_total
  end

end
