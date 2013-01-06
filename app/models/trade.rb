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

	validate :company_id, :presence => true

	def total_fees
		taxes + commission_total
	end

	def gain
		return nil if price_sold.nil?
		shares * (price_sold - price_bought) - total_fees
	end

	def performance
		return nil if gain.nil?
		"#{(gain / (price_bought * shares) * 100).to_i} %"
	end

private

	def total_bought
		shares * price_bought
	end

end