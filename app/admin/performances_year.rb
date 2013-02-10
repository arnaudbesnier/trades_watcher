ActiveAdmin.register_page "Performances" do
  menu :priority => 1

  content do
    cell_style_bold = 'display: table-cell; background: white;'
    cell_style = 'display: table-cell; background: white; font-weight: normal; text-shadow: none;'

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
          tr :class => (year.modulo(2) == 0 ? 'odd' : 'even') do
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