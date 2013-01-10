class Quote < ActiveRecord::Base

	attr_accessible :company_id, :value, :volume, :created_at,
					:value_day_open, :value_day_low, :value_day_high,
					:variation_day_current, :variation_day_low, :variation_day_high


	belongs_to :company

	validates :company_id, :uniqueness => { :scope => :created_at }

end