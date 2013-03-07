# == Schema Information
#
# Table name: portfolio_performances
#
#  id             :integer          not null, primary key
#  period_type_id :integer
#  time_close     :datetime
#  value_close    :decimal(, )
#  value_open     :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PortfolioPerformance < ActiveRecord::Base

end
