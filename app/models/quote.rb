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
      :company_id     => company_id,
      :period_type_id => CompanyPerformance::PERIOD_DAY,
      :closed_at      => created_at,
      :value_open     => value_day_open,
      :value_close    => value,
      :value_high     => value_day_high,
      :value_low      => value_day_low
    }
    day  = created_at.to_date
    perf = company.performances.where('closed_at > ? AND closed_at < ?', day, day + 1.day).first
    if perf
      perf.update_attributes(perf_attributes)
    else
      perf_attributes[:value_last] = company.performances.where('closed_at < ?', day).order('closed_at DESC').first.value_close
      CompanyPerformance.create!(perf_attributes)
    end
  end

end
