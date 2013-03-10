# == Schema Information
#
# Table name: portfolio_performances
#
#  id             :integer          not null, primary key
#  period_type_id :integer
#  closed_at      :datetime
#  value_close    :decimal(, )
#  value_open     :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  closings       :integer
#  trade_gains    :decimal(, )
#

class PortfolioPerformance < ActiveRecord::Base

  PERIOD_DAY = 1

  PERIOD_TYPE = {
    :day => PERIOD_DAY
  }

  # TODO: make it work
  def self.create_or_update_today
  	today = Date.today
  	if performance = self.where('closed_at > ? AND closed_at < ?', today, today + 1.day).first
  	  performance.value_closed
  	else
  	  performance                = PortfolioPerformance.new
  	  performance.period_type_id = PERIOD_DAY

  	  value_open
  	  value_close
  	end

  	performance.closed_at = Time.now
  	performance.save!
  end

end
