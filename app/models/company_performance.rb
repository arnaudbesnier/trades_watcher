# == Schema Information
#
# Table name: company_performances
#
#  id             :integer          not null, primary key
#  company_id     :integer
#  period_type_id :integer
#  closed_at      :datetime
#  value_close    :decimal(, )
#  value_open     :decimal(, )
#  value_high     :decimal(, )
#  value_low      :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  value_last     :decimal(, )
#

class CompanyPerformance < ActiveRecord::Base

  PERIOD_DAY  = 1
  PERIOD_WEEK = 2

  PERIOD_TYPE = {
    :day  => PERIOD_DAY,
    :week => PERIOD_WEEK
  }

  attr_accessor :variation

  belongs_to :company

  scope :day,  where(:period_type_id => PERIOD_DAY)
  scope :week, where(:period_type_id => PERIOD_WEEK) 

  validates :company_id, :uniqueness => { :scope => [:period_type_id, :closed_at] }

  def self.find_day_top_worst_5 day=Date.today
    performances = self.where('closed_at >= ? AND closed_at < ?', day, day + 1.day).all

    return [[], []] if performances.empty?

    performances.each do |performance|
      performance.variation = performance.gain_and_variation[1]
    end

    performances.sort! { |a, b| b.variation.to_f <=> a.variation.to_f }
    [performances[0..4], performances[-5, 5].reverse!]
  end

  def gain_and_variation
    return [nil, nil] unless value_last

    gain      = value_close - value_last
    variation = gain / value_last * 100
    [gain, variation]
  end
end

class PerformanceTemp

  attr_reader :deposits, :dividends_net, :closings, :trade_gains,
              :stock_value, :liquidity, :valorization,
              :performance_stock, :performance_period, :performance_total,
              :variation_stock, :variation_period, :variation_total

  def initialize begin_date=Time.new(2011), end_date=Time.now
    begin_story, now = Time.new(2011), Time.now
    period_size      = end_date - begin_date

    @deposits            = Transaction.deposit_total(begin_date, end_date)
    @closings            = Trade.closed_between(begin_date, end_date).count
    @trade_gains         = Trade.sold_stock_gain(begin_date, end_date)
    @stock_value         = Trade.stock_value(end_date)
    stock_purchase_value = Trade.stock_purchase_value

    @deposits_total    = Transaction.deposit_total(begin_story, end_date)
    @dividends_net     = Dividend.total_net(begin_story, end_date)
    @trade_gains_total = Trade.sold_stock_gain(begin_story, end_date)
    @liquidity         = @deposits_total + @dividends_net + @trade_gains_total - stock_purchase_value

    @valorization       = @stock_value + @liquidity
    @performance_stock  = @stock_value - stock_purchase_value
    @performance_period = @stock_value - Trade.stock_value(end_date - period_size)
    @performance_total  = @valorization - @deposits_total

    @variation_stock  = @performance_stock / stock_purchase_value * 100
    @variation_period = @performance_period / (@valorization - @performance_period) * 100
    @variation_total  = @performance_total / @deposits_total * 100
  end
end
