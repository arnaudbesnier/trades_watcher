# == Schema Information
#
# Table name: portfolio_performances
#
#  id             :integer          not null, primary key
#  period_type_id :integer
#  closed_at      :datetime
#  value_close    :decimal(, )
#  value_open     :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  closings       :integer
#  trade_gains    :decimal(, )
#

class PortfolioPerformance < ActiveRecord::Base

  PERIOD_DAY = 1

  PERIOD_TYPE = {
    :day => PERIOD_DAY
  }

  scope :day, where(:period_type_id => PERIOD_DAY)

  def self.create_or_update_today
  	today  = Date.today
  	trades = Trade.includes(:order_open).opened

  	unless performance = self.where('closed_at > ? AND closed_at < ?', today, today + 1.day).first
  	  performance                = PortfolioPerformance.new
  	  performance.period_type_id = PERIOD_DAY
  	end

    performance.value_open = trades.inject(0) do |sum, trade|
      if trade.order_open.executed_at.to_date == today
        sum += trade.shares * trade.order_open.price
      else
        sum += trade.shares * trade.company.quotes.order('created_at DESC').limit(1).first.value_day_open
      end
    end

  	performance.value_close = trades.inject(0) do |sum, trade|
      sum += trade.shares * trade.company.quotes.order('created_at DESC').limit(1).first.value
  	end
  	performance.closed_at = Time.now
  	performance.save!
  end

  def value_last
    @value_last = PortfolioPerformance.where(:period_type_id => period_type_id)
                                      .where('closed_at < ?', created_at.to_date)
                                      .order('closed_at DESC').first.value_close
  end

  def gain_and_variation
    closed_trades = Order.sell_today.inject(0) { |sum, order| sum += order.value }
    opened_trades = Order.buy_today.inject(0)  { |sum, order| sum += order.value }

    gain      = value_close - value_last + closed_trades - opened_trades
    variation = gain / value_last * 100
    [gain, variation]
  end

end

class CurrentPortfolioPerformance

  attr_reader :current_value, :deposit_total, :liquidity, :valorization,
              :trades_max_loss_and_ratio, :stock_value, :day_performance,
              :performance_stock, :variation_stock, :performance_total, :variation_total

  def initialize
    begin_story = Time.new(2011)
    end_date    = Date.today + 1.day

    current_portfolio_performance = PortfolioPerformance.day.last

    @current_value             = current_portfolio_performance.value_close
    @day_performance           = current_portfolio_performance.gain_and_variation
    @deposit_total             = Transaction.deposit_total(begin_story, end_date)
    stock_purchase_value       = Trade.stock_purchase_value
    @stock_value               = Trade.stock_value(end_date)
    dividend_total             = Dividend.total_net(begin_story, end_date)
    @trade_gains_total         = Trade.sold_stock_gain(begin_story, end_date)
    @liquidity                 = @deposit_total + dividend_total + @trade_gains_total - stock_purchase_value
    @valorization              = @stock_value + @liquidity
    @performance_total         = valorization - deposit_total
    @variation_total           = performance_total / deposit_total * 100
    @trades_max_loss_and_ratio = Trade.max_loss_and_ratio
    @performance_stock         = @stock_value - stock_purchase_value
    @variation_stock           = @performance_stock / stock_purchase_value * 100
  end
end