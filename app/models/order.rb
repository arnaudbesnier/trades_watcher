# encoding: utf-8

# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  shares      :integer
#  price       :decimal(, )
#  order_type  :integer
#  commission  :decimal(, )
#  taxes       :decimal(, )
#  created_at  :datetime
#  executed    :boolean
#  executed_at :datetime
#

class Order < ActiveRecord::Base

  BUY            = 1
  SELL           = 2
  SELL_STOP_LOSS = 3
  SELL_STOP_GAIN = 4
  BUY_START_GAIN = 5

  TYPE_NAMES = {
  	BUY            => :buy,
    BUY_START_GAIN => :buy_start_gain,
  	SELL           => :sell,
  	SELL_STOP_LOSS => :sell_stop_loss,
  	SELL_STOP_GAIN => :sell_stop_gain
  }

  TYPE_COLORS = {
    BUY            => '#4C787E',
    BUY_START_GAIN => '#4C787E',
    SELL           => '#91FC17',
    SELL_STOP_LOSS => '#8217FC',
    SELL_STOP_GAIN => '#FDD017'
  }

  TYPE_IDS = TYPE_NAMES.invert

  attr_accessor :data
  attr_protected :id, :executed

  belongs_to :company

  scope :executed,       where(:executed => true)
  scope :pending,        where(:executed => false)
  scope :buy,            where(:order_type => BUY)
  scope :sell,           where(:order_type => [SELL, SELL_STOP_LOSS, SELL_STOP_GAIN])
  scope :sell_stop_loss, where(:order_type => SELL_STOP_LOSS)


  scope :buy_day,  lambda { |date| buy.where('executed_at > ? AND executed_at < ?', date, date + 1.day) }
  scope :sell_day, lambda { |date| sell.where('executed_at > ? AND executed_at < ?', date, date + 1.day) }

  validates :company_id, :presence => true
  validates :shares,     :presence => true
  validates :price,      :presence => true
  validates :order_type, :presence => true
  validates :created_at, :presence => true
  #validates :executed,   :inclusion => { :in => [true, false] }

  validates :company_id, :uniqueness => { :scope => [:order_type, :created_at] }

  before_save  :check_execution
  before_save  :set_taxe_and_commission
  after_save   :create_trade,  :if => :buy_order_executed?
  after_save   :update_trades, :if => :sell_order_executed?

  # ActiveAdmin display
  def name
    "#{TYPE_NAMES[order_type].upcase} | #{company.symbol} - #{format_price_display(value)}"
  end

  def value
    shares * price
  end

  def total
    if buy_order?
      value + total_fees
    elsif sell_order?
      value - total_fees
    end
  end

  def self.parse_email_data data
    computed_data = {}
    day, month, year = /Date d'ordre:\t(\d{2})\/(\d{2})\/(\d{4})/.match(data)[1..3]
    hour, minutes    = /Heure:\t(\d{2}):(\d{2}):\d{2}/.match(data)[1..2]

    total = /Montant final:\s*Cr ([\d.]*[,\s]*\d{2}) EUR/.match(data)[1].gsub('.', '').gsub(',', '.').to_f
    date  = Time.new(year, month, day, hour, minutes)

    computed_data[:shares]      = /Quantité:\t(\d*)/.match(data)[1].to_i
    computed_data[:price]       = /Prix unitaire:\t(\d*,\d*) EUR/.match(data)[1].gsub(',', '.')
    computed_data[:commission]  = total > 1000 ? 5.0 : 2.5 # TODO: handle greater commissions

    computed_data['created_at(1i)'] = year
    computed_data['created_at(2i)'] = month
    computed_data['created_at(3i)'] = day
    computed_data['created_at(4i)'] = hour
    computed_data['created_at(5i)'] = minutes

    computed_data['executed_at(1i)'] = year
    computed_data['executed_at(2i)'] = month
    computed_data['executed_at(3i)'] = day
    computed_data['executed_at(4i)'] = hour
    computed_data['executed_at(5i)'] = minutes

    computed_data
  end

private

  def just_executed?
    executed_changed? && executed
  end

  def buy_order?
    [BUY, BUY_START_GAIN].include?(order_type)
  end

 def sell_order?
    [SELL, SELL_STOP_LOSS, SELL_STOP_GAIN].include?(order_type)
  end

  def buy_order_executed?
     buy_order? && just_executed?
  end

  def sell_order_executed?
     sell_order? && just_executed?
  end

  def total_fees
    taxes + commission
  end

  def check_execution
    self.executed = !!executed_at
    true
  end

  def set_taxe_and_commission
    self.taxes      ||= 0.0
    self.commission ||= 0.0
  end

  def create_trade
    Trade.create({
      :company_id    => company_id,
      :shares        => shares,
      :order_open_id => id
    })
  end

  def update_trades
    shares_sold = shares

    Trade.opened.where(:company_id => company_id).order('created_at ASC').each do |trade|
      if shares_sold > 0
        trade.update_attributes({ :order_close_id => id })
        shares_sold -= trade.shares

        day_performance = PortfolioPerformance.day.last
        day_performance.closings    += 1
        day_performance.trade_gains += trade.gain
        day_performance.save!
        # TODO : handle trades that are not fully closed by creating a new clone trade
      else
        return
      end
    end
  end
end
