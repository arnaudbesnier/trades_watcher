# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  created_at :date
#  type       :integer
#  amount     :decimal(, )
#

class Transaction < ActiveRecord::Base

  attr_accessible :transaction_type, :amount, :created_at

  validates :transaction_type, :presence => true
  validates :amount,           :presence => true
  validates :created_at,       :presence => true

  DEPOSIT  = 1
  WITHDRAW = 2

  TYPES = { 
  	DEPOSIT  => :deposit,
  	WITHDRAW => :withdraw
  }

end
