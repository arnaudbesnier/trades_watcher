# == Schema Information
#
# Table name: dividends
#
#  id          :integer          not null, primary key
#  company_id  :integer
#  shares      :integer
#  received_at :date
#  amount      :decimal(, )
#  taxes       :decimal(, )
#

class Dividend < ActiveRecord::Base

  attr_accessible :company_id, :shares, :received_at,
                  :amount, :taxes

  belongs_to :company

  validates :company_id,  :presence => true
  validates :shares,      :presence => true
  validates :received_at, :presence => true
  validates :amount,      :presence => true
  validates :taxes,       :presence => true

  validates :company_id, :uniqueness => { :scope => :received_at }

  def self.total_net begin_date, end_date
    dividends_total = 0
    dividends       = self.where('received_at > ? AND received_at < ?', begin_date, end_date)
    dividends.each { |dividend| dividends_total += dividend.total_net }
    dividends_total
  end

  # ActiveAdmin display
  def name
    "#{company.name} [#{format_price_display(total_net)}] - #{format_date(received_at)}"
  end

  def total_gross
    amount * shares
  end

  def total_net
  	total_gross * (1 - taxes)
  end

end