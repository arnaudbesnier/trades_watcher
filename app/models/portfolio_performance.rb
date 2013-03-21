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

  def gain_and_variation
    gain      = value_close - value_open
    variation = gain / value_open * 100
    [gain, variation]
  end

end
