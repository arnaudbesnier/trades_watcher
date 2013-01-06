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
#

class Trade < ActiveRecord::Base

	attr_accessible :opened_at, :closed_at, :shares,
					:price_bought, :price_sold,
					:commission_total, :taxes

	scope :opened, where('closed_at IS NULL') 
	scope :closed, where('closed_at IS NOT NULL')

end
