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

  after_create :set_performances

  def variation_price_current
    (1 - 1 / (100 + variation_day_current) * 100) * value
  end

private

  def set_performances
    perf_attributes = {
      :closed_at   => created_at,
      :value_close => value,
      :value_high  => value_day_high,
      :value_low   => value_day_low
    }

    day            = created_at.to_date
    week_start_day = Date.commercial(day.year, day.cweek, 1)

    perf_day  = company.performances.day.where('closed_at > ? AND closed_at < ?', day, day + 1.day).first
    perf_week = company.performances.week.where('closed_at > ? AND closed_at < ?', week_start_day, week_start_day + 6.day).first
    
    if perf_day
      perf_day.update_attributes(perf_attributes)
    else
      CompanyPerformance.create!({
        :company_id     => company_id,
        :period_type_id => CompanyPerformance::PERIOD_DAY,
        :value_open     => value_day_open,
        :value_last     => company.performances.day.where('closed_at < ?', day).order('closed_at DESC').first.value_close
      }.merge(perf_attributes))
    end

    if perf_week
      perf_attributes[:value_high] = perf_week.value_high if perf_week.value_high > perf_attributes[:value_high]
      perf_attributes[:value_low]  = perf_week.value_low  if perf_week.value_low  < perf_attributes[:value_low]
      perf_week.update_attributes(perf_attributes)
    else
      last_perf = company.performances.week.where('closed_at < ?', week_start_day).order('closed_at DESC').first
      CompanyPerformance.create!({
        :company_id     => company_id,
        :period_type_id => CompanyPerformance::PERIOD_WEEK,
        :value_open     => value_day_open,
        :value_last     => last_perf ? last_perf.value_close : nil
      }.merge(perf_attributes))
    end
  end

end