class CurrentSituation

  attr_reader :deposits, :stock_value, :liquidity,
              :valorization, :performance

  def initialize
    now = Time.now

    @deposits     = Transaction.deposit_total
    @stock_value  = Trade.stock_current_value
    @liquidity    = @deposits + Trade.sold_stock_gain + Dividend.total_net - Trade.stock_purchase_value

    @valorization = @stock_value + @liquidity
    @performance  = (@valorization - @deposits) / @deposits * 100 
  end

end
