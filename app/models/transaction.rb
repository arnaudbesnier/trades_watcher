# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  transaction_type :integer
#  amount           :decimal(, )
#  created_at       :date
#

class Transaction < ActiveRecord::Base

  attr_accessible :transaction_type, :amount, :created_at

  validates :transaction_type, :presence => true
  validates :amount,           :presence => true
  validates :created_at,       :presence => true

  validates :amount, :uniqueness => { :scope => :created_at }

  DEPOSIT  = 1
  WITHDRAW = 2

  TYPES = { 
  	DEPOSIT  => :deposit,
  	WITHDRAW => :withdraw
  }

  scope :deposits, where(:transaction_type => DEPOSIT)
  scope :withdraw, where(:transaction_type => WITHDRAW)

  def self.deposit_total begin_date, end_date
    transactions = self.where('created_at > ? AND created_at < ?', begin_date, end_date)
    transactions.deposits.sum(:amount) - transactions.withdraw.sum(:amount)
  end

  def amount_signed
    transaction_type == DEPOSIT ? amount : -amount
  end

end
