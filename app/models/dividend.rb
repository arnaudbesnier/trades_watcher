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

  validates :company_id,  :presence => true
  validates :shares,      :presence => true
  validates :received_at, :presence => true
  validates :amount,      :presence => true
  validates :taxes,       :presence => true

  belongs_to :company

end