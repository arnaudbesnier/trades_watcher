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

  attr_accessible :company_id, :shares, :price, :order_type,
                  :commission, :taxes,
                  :created_at, :executed, :executed_at

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

  belongs_to :company

  scope :executed, where(:executed => true)
  scope :pending,  where(:executed => false)

  validates :company_id, :presence => true
  validates :shares,     :presence => true
  validates :price,      :presence => true
  validates :order_type, :presence => true
  validates :created_at, :presence => true
  validates :executed,   :inclusion => { :in => [true, false] }

  validates :company_id, :uniqueness => { :scope => [:order_type, :created_at] }

end
