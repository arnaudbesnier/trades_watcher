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

	def total_bought
		shares * price_bought
	end

	def total_sold
		return nil unless price_sold
		shares * price_sold
	end

end
