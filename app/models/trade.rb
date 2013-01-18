# == Schema Information
#
# Table name: trades
#
#  id               :integer          not null, primary key
#  price_bought     :decimal(, )
#  price_sold       :decimal(, )
#  shares           :integer
#  opened_at        :datetime
#  closed_at        :datetime
#  commission_total :decimal(, )
#  taxes            :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer
#

class Trade < ActiveRecord::Base

  attr_accessible :company_id, :shares,
                  :opened_at, :closed_at,
                  :price_bought, :price_sold,
                  :commission_total, :taxes

  scope :opened, where('closed_at IS NULL') 
  scope :closed, where('closed_at IS NOT NULL')

  belongs_to :company

  validate :company_id,       :presence => true
  validate :shares,           :presence => true
  validate :opened_at,        :presence => true
  validate :price_bought,     :presence => true
  validate :commission_total, :presence => true
  validate :taxes,            :presence => true

  def total_fees
    taxes + commission_total
  end

  def gain
    if price_sold
      value = price_sold
    else
      return nil unless company.quotes.last
      value = company.quotes.last.value
    end
    shares * (value - price_bought) - total_fees
  end

  def performance
    return nil unless gain
    gain / (price_bought * shares) * 100
  end

private

  def total_bought
    shares * price_bought
  end

end
