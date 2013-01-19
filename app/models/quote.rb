# == Schema Information
#
# Table name: quotes
#
#  id                    :integer          not null, primary key
#  company_id            :integer
#  value                 :decimal(, )
#  value_day_open        :decimal(, )
#  value_day_low         :decimal(, )
#  value_day_high        :decimal(, )
#  variation_day_low     :decimal(, )
#  variation_day_high    :decimal(, )
#  variation_day_current :decimal(, )
#  volume                :integer
#  created_at            :datetime
#

class Quote < ActiveRecord::Base

  attr_accessible :company_id, :value, :volume, :created_at,
                  :value_day_open, :value_day_low, :value_day_high,
                  :variation_day_current, :variation_day_low, :variation_day_high

  belongs_to :company

  validates :company_id, :uniqueness => { :scope => :created_at }

  def variation_price_current
    (1 - 1 / (100 + variation_day_current) * 100) * value
  end

end
