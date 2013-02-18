ActiveAdmin.register_page "Performances" do

  menu :priority => 1

  content do
    today       = Date.today
    year        = today.year
    week_number = today.cweek
    week_day    = lambda { |day_number| Date.commercial(year, week_number, day_number).strftime('%A, %b %d %Y') }
    year_week   = lambda { |week_number| Date.commercial(year, week_number, 1).strftime('Week %U - %B %Y') }

    cell_style_bold = 'display: table-cell; background: white;'
    cell_style      = 'display: table-cell; background: white; font-weight: normal; text-shadow: none;'

    current_performance = Performance.new

    h3 'CURRENT SITUATION'
    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'DEPOSITS' }
          th { 'STOCK' }
          th { 'LIQUIDITY' }
          th { 'VALORIZATION' }
          th { 'STOCK MAX LOSS' }
          th { 'PERFORMANCE' }
        end
        tr do
          th :style => cell_style do format_price(current_performance.deposits) end
          th :style => cell_style do format_price(current_performance.stock_value) end
          th :style => cell_style do format_price(current_performance.liquidity) end
          th :style => cell_style do format_price(current_performance.valorization) end
          th :style => cell_style do format_price_and_variation(*Trade.max_loss_and_ratio) end
          th :style => cell_style do format_price_and_variation(current_performance.performance_total, current_performance.variation_total) end
        end
      end
    end

    br
    h3 'WEEK PERFORMANCE'
    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'DAY' }
          th { 'CLOSINGS' }
          th { 'TRADE GAINS' }
          th { 'VALORIZATION' }
          th { 'PERFORMANCE DAY' }
          th { 'PERFORMANCE TOTAL' }
        end
        5.downto(1) do |day|
          begin_day   = Date.commercial(year, week_number, day)
          displayable = begin_day <= Date.today
          if displayable
            end_day         = Date.commercial(year, week_number, day + 1)
            day_performance = Performance.new(begin_day, end_day)
          end
          tr do
            th :style => cell_style_bold do week_day.call(day) end
            th :style => cell_style do format_integer(day_performance.closings)            if displayable end
            th :style => cell_style do format_price_with_sign(day_performance.trade_gains) if displayable end
            th :style => cell_style do format_price(day_performance.valorization)          if displayable end
            th :style => cell_style do
              if displayable
                format_price_and_variation(day_performance.performance_period, day_performance.variation_period)
              end
            end
            th :style => cell_style do
              if displayable
                format_price_and_variation(day_performance.performance_total, day_performance.variation_total)
              end
            end
          end
        end
      end
    end

    br
    h3 'MONTH PERFORMANCE'
    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'WEEK' }
          th { 'CLOSINGS' }
          th { 'TRADE GAINS' }
          th { 'VALORIZATION' }
          th { 'PERFORMANCE WEEK' }
          th { 'PERFORMANCE TOTAL' }
        end
        0.upto(4) do |week|
          current_week_number = week_number - week
          begin_day   = Date.commercial(year, current_week_number, 1)
          displayable = begin_day <= Date.today
          if displayable
            end_day          = Date.commercial(year, current_week_number + 1, 1)
            week_performance = Performance.new(begin_day, end_day)
          end
          tr do
            th :style => cell_style_bold do year_week.call(current_week_number) end
            th :style => cell_style do format_integer(week_performance.closings)            if displayable end
            th :style => cell_style do format_price_with_sign(week_performance.trade_gains) if displayable end
            th :style => cell_style do format_price(week_performance.valorization)          if displayable end
            th :style => cell_style do
              if displayable
                format_price_and_variation(week_performance.performance_period, week_performance.variation_period)
              end
            end
            th :style => cell_style do
              if displayable
                format_price_and_variation(week_performance.performance_total, week_performance.variation_total)
              end
            end
          end
        end
      end
    end

    br
    h3 'ANNUAL SUMMARY'
    table :class => 'index_table', :style => 'display: table;' do
      tbody do
        tr do
          th { 'YEAR' }
          th { 'DEPOSIT TOTAL' }
          th { 'CLOSINGS' }
          th { 'TRADE GAINS' }
          th { 'DIVIDENDS' }
          th { 'VALORIZATION' }
          th { 'PERFORMANCE YEAR' }
          th { 'PERFORMANCE TOTAL' }
        end

        Time.now.year.downto(2011) do |year|
          tr do
            annual = Annual.new(year)
            th :style => cell_style_bold do annual.year end
            th :style => cell_style do format_price(annual.deposits_total) end
            th :style => cell_style do format_integer(annual.closings) end
            th :style => cell_style do format_price_and_variation(annual.trade_gains, annual.trade_gains_performance) end
            th :style => cell_style do format_price_and_variation(annual.dividends, annual.dividends_performance) end
            th :style => cell_style do format_price(annual.valorization) end
            th :style => cell_style do format_price_and_variation(annual.gain_year, annual.performance_year) end
            th :style => cell_style do format_price_and_variation(annual.gain_total, annual.performance_total) end
          end
        end
      end
    end
  end
end