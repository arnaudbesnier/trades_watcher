# == Schema Information
#
# Table name: companies
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  symbol    :string(255)
#  sector_id :integer
#  index     :string(255)
#

class Company < ActiveRecord::Base

  attr_accessible :name, :symbol, :sector_id, :index

  validates :name,   :uniqueness => true
  validates :symbol, :uniqueness => true

  belongs_to :sector

  has_many :quotes
  has_many :trades

  scope :portfolio, lambda {
  	company_ids = Trade.opened.pluck(:company_id)
  	Company.where(:id => company_ids)
  }
  scope :CAC40,  where(:index => 'CAC40')
  scope :SBF120, where(:index => 'SBF120')

  #def self.cac40_ranking cac40_company
  #  return {} unless self.CAC40.where(:id => cac40_company.id).any?
  #  day_ranking = []
  #  self.CAC40.each do |company|
  #    day_performance = company.day_performance
  #    day_ranking << {
  #      :company     => company.id,
  #      :gain        => day_performance[0],
  #      :performance => day_performance[1]
  #    }
  #  end
  #  day_ranking.sort! { |a, b| b[:gain] <=> a[:gain] }
  #  day_ranking.each_with_index { |performance, i| performance[:rank] = i + 1 }
  #  puts "\n\n#{day_ranking.inspect}"

  #  day_ranking.detect { |company|
  #    company[:company].to_i == cac40_company.id }
  #end

  def self.portfolio_proportions_chart display_options={}
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Company')
    data_table.new_column('number', 'Value')
    data = []

    portfolio.each do |company|
      company_value = Trade.opened.where(:company_id => company.id).inject(0) { |sum, company| sum += company.current_value }
      data << [company.symbol, company_value]
    end

    data_table.add_rows(data)

    GoogleVisualr::Interactive::PieChart.new(data_table, display_options)
  end

  def has_opened_trade?
    trades.opened.any?
  end

  def last_value day=Date.today
    quote = quotes.where('created_at < ?', day + 1).order('created_at DESC').first
    quote ? quote.value : nil
  end

  def portfolio_proportion
    return nil unless has_opened_trade?

    stock_total_value    = Performance.new.stock_value
    company_trades_value = trades.opened.inject(0) { |accum, trade| accum + trade.current_value }
    company_trades_value / stock_total_value
  end

  def week_variance
    today       = Date.today
    year        = today.year
    week_number = today.cweek

    values = []

    1.upto(5) do |day|
      current_day = Date.commercial(year, week_number, day)
      values << performance_day(current_day)[1]
    end

    values.compact!

    return nil if values.length == 0
    Statistics::Serie.new(values).deviation
  end

  #def day_performance date=Time.now
  #  last_quote = quotes.where('created_at < ?', date).last
  #  [last_quote.variation_price_current, last_quote.variation_day_current]
  #end

  def week_candlechart
    last_quote_date = quotes.last.created_at
    last_quote_date = Date.new(last_quote_date.year, last_quote_date.month, last_quote_date.day)
    day_candle_data = []

    6.downto(0) do |number|
      day_quote = quotes.where('created_at >= ? AND created_at <= ?', last_quote_date - number.day, last_quote_date - (number - 1).day ).last
      if day_quote
        day_candle_data << [day_quote.created_at.day.to_s, day_quote.value_day_low, day_quote.value_day_open, day_quote.value, day_quote.value_day_high]
      end
    end

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'time')
    data_table.new_column('number', 'min')
    data_table.new_column('number', 'opening')
    data_table.new_column('number', 'closing')
    data_table.new_column('number', 'max')
    data_table.add_rows(day_candle_data)
    data_table
  end

private

  def performance_day date=Time.now
    last_quote = quotes.where('created_at < ?', date).last
    [last_quote.variation_price_current, last_quote.variation_day_current]
  end

end
