ActiveAdmin.register_page "Performances" do
  menu :priority => 1

  content do
    today       = Date.today
    year        = today.year
    week_number = today.cweek
    week_day    = lambda { |day_number| Date.commercial(year, week_number, day_number).strftime('%A, %b %d %Y') }
    year_week   = lambda { |week_number| Date.commercial(year, week_number, 1).strftime('Week %U - %B %Y') }

    cell_style_bold = 'display: table-cell; background: white;'
    cell_style = 'display: table-cell; background: white; font-weight: normal; text-shadow: none;'

    current_situation = CurrentSituation.new

    h3 'CURRENT SITUATION'
    # TODO: fill in the table
    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'DEPOSITS' }
          th { 'STOCK' }
          th { 'LIQUIDITY' }
          th { 'VALORIZATION' }
          th { 'PERFORMANCE' }
        end
        tr do
          th :style => cell_style do format_price(current_situation.deposits) end
          th :style => cell_style do format_price(current_situation.stock_value) end
          th :style => cell_style do format_price(current_situation.liquidity) end
          th :style => cell_style do format_price(current_situation.valorization) end
          th :style => cell_style do format_variation(current_situation.performance) end
        end
      end
    end

    br
    h3 'WEEK PERFORMANCE'
    # TODO: fill in the table
    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'DAY' }
          th { 'GAIN' }
          th { 'VALORIZATION' }
          th { 'PERFORMANCE' }
        end
        1.upto(5) do |day|
          tr do
            th :style => cell_style_bold do week_day.call(day) end
            th :style => cell_style do end
            th :style => cell_style do end
            th :style => cell_style do end
          end
        end
      end
    end

    br
    h3 'MONTH PERFORMANCE'
    # TODO: fill in the table
    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'WEEK' }
          th { 'GAIN' }
          th { 'VALORIZATION' }
          th { 'PERFORMANCE' }
        end
        0.upto(4) do |week|
          tr do
            th :style => cell_style_bold do year_week.call(week_number - week) end
            th :style => cell_style do end
            th :style => cell_style do end
            th :style => cell_style do end
          end
        end
      end
    end

    br
    h3 'YEAR PERFORMANCE'

    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'YEAR' }
          th { 'TRADE GAINS' }
          th { 'CLOSINGS' }
          th { 'DIVIDENDS' }
          th { 'DEPOSIT TOTAL' }
          th { 'VALORIZATION' }
          th { 'PERFORMANCE YEAR' }
          th { 'PERFORMANCE TOTAL' }
        end

        Time.now.year.downto(2011) do |year|
          tr do
            gain = GainPerYear.new(year)
            th :style => cell_style_bold do "#{gain.year}" end
            th :style => cell_style do "#{format_variation_price(gain.trade_gains)}" end
            th :style => cell_style do "#{format_integer(gain.closings)}" end
            th :style => cell_style do "#{format_variation_price(gain.dividends)}" end
            th :style => cell_style do "#{format_price(gain.deposits_total)}" end
            th :style => cell_style do "#{format_price(gain.valorization)}" end
            th :style => cell_style do "#{format_variation(gain.performance_year)}" end
            th :style => cell_style do "#{format_variation(gain.performance_total)}" end
          end
        end
      end
    end
  end
end