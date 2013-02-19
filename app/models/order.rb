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

  TYPE_NAMES = {
  	BUY            => :buy,
  	SELL           => :sell,
  	SELL_STOP_LOSS => :sell_stop_loss,
  	SELL_STOP_GAIN => :sell_stop_gain
  }

  TYPE_COLORS = {
    BUY            => '#4C787E',
    SELL           => '#91FC17',
    SELL_STOP_LOSS => '#8217FC',
    SELL_STOP_GAIN => '#FDD017'
  }

  TYPE_IDS = TYPE_NAMES.invert

  attr_protected :id, :executed

  belongs_to :company

  scope :executed,       where(:executed => true)
  scope :pending,        where(:executed => false)
  scope :buy,            where(:order_type => BUY)
  scope :sell,           where(:order_type => [SELL, SELL_STOP_LOSS, SELL_STOP_GAIN])
  scope :sell_stop_loss, where(:order_type => SELL_STOP_LOSS) 

  validates :company_id, :presence => true
  validates :shares,     :presence => true
  validates :price,      :presence => true
  validates :order_type, :presence => true
  validates :created_at, :presence => true
  #validates :executed,   :inclusion => { :in => [true, false] }

  validates :company_id, :uniqueness => { :scope => [:order_type, :created_at] }

  before_save  :check_execution
  before_save  :set_taxe_and_commission
  after_create :create_trade,  :if => :buy_order?
  after_save   :update_trades, :if => :sell_order?

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

private

  def buy_order?
    [BUY].include? order_type 
  end

  def sell_order?
    [SELL, SELL_STOP_LOSS, SELL_STOP_GAIN].include?(order_type) && executed
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
        # TODO : handle trades that are not fully closed by creating a new clone trade
      else
        return
      end
    end
  end
end
