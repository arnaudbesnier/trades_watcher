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

  after_create :set_day_performance

  def variation_price_current
    (1 - 1 / (100 + variation_day_current) * 100) * value
  end

private

  def set_day_performance
    perf_attributes = {
	  :company_id     => company.id,
	  :period_type_id => Performance::PERIOD_DAY,
	  :time_close     => created_at,
	  :value_open     => value_day_open,
	  :value_close    => value,
  	  :value_high     => value_day_high,
  	  :value_low      => value_day_low
	}
	day  = created_at.to_date
	perf = Performance.where('company_id = ? AND time_close > ? AND time_close < ?', company_id, day, day + 1.day).first
	perf ? perf.update_attributes(perf_attributes) : Performance.create!(perf_attributes)
  end

end
