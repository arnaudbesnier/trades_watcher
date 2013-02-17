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

  def has_opened_trade?
    Trade.opened.where(:company_id => self).any?
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

end
