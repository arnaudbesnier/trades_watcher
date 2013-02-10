# == Schema Information
#
# Table name: trades
#
#  id             :integer          not null, primary key
#  shares         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  company_id     :integer
#  order_open_id  :integer
#  order_close_id :integer
#

class Trade < ActiveRecord::Base

  attr_accessible :company_id, :shares,
                  :order_open_id, :order_close_id

  scope :opened, where('order_close_id IS NULL') 
  scope :closed, where('order_close_id IS NOT NULL')

  belongs_to :company
  belongs_to :order_open,  :class_name => 'Order'
  belongs_to :order_close, :class_name => 'Order'

  validate :company_id,    :presence => true
  validate :shares,        :presence => true
  validate :order_open_id, :presence => true

  #validates :company_id, :uniqueness => { :scope => [:order_open_id, :order_close_id] }

  def sold_value
    return nil unless order_close
    order_close.value * shares / order_close.shares
  end

  def total_fees
    taxes_total      =  order_open.taxes
    taxes_total      += order_close.taxes if order_close
    commission_total =  order_open.commission
    commission_total += (order_close.commission * shares) / order_close.shares if order_close
    taxes_total + commission_total
  end

  def gain
    if order_close
      value = order_close.price
    else
      return nil unless company.quotes.last
      value = company.quotes.last.value
    end
    shares * (value - order_open.price) - total_fees
  end

  def performance
    return nil unless gain
    gain / (order_open.price * shares) * 100
  end

private

  def total_bought
    shares * price_bought
  end

end
