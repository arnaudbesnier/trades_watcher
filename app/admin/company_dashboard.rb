ActiveAdmin.register_page 'Company Perfs' do

  menu :parent => 'Dashboard', :label => 'Company'

  content do
    today       = Date.today
    year        = today.year
    week_number = today.cweek
    week_day    = lambda { |day_number| Date.commercial(year, week_number, day_number).strftime('%A, %b %d %Y') }
    year_week   = lambda { |week_number| Date.commercial(year, week_number, 1).strftime('Week %U - %B %Y') }

    last_day    = today.cwday < 6 ? today.cwday : 5
    current_day = Date.commercial(year, week_number, last_day)
    day_top_5, day_worst_5 = CompanyPerformance.find_day_top_worst_5 current_day

    cell_style_bold = 'display: table-cell; background: white;'
    cell_style      = 'display: table-cell; background: white; font-weight: normal; text-shadow: none;'

    h3 'DAY'
    div :style => 'width: 48%; float: left' do
      table :class => 'index_table', :style => 'display: table;' do
        tbody do
          tr do
            th { 'TOP' }
            th { 'COMPANY' }
            th { 'VARIATION' }
            th { 'GAIN' }
            #th { 'PORTFOLIO ?' }
          end
          day_top_5.each_with_index do |performance, index|
            tr do
              th :style => cell_style_bold do index + 1 end
              th :style => cell_style do link_to performance.company.name, admin_company_path(performance.company_id) end
              th :style => cell_style do format_variation(performance.gain_and_variation[1]) end
              th :style => cell_style do format_price(performance.gain_and_variation[0]) end
              #th :style => cell_style do end
            end
          end
        end
      end
    end
    div :style => 'margin-left: 2%; width: 48%; float: left;' do
      table :class => 'index_table', :style => 'display: table;' do
        tbody do
          tr do
            th { 'TOP' }
            th { 'COMPANY' }
            th { 'VARIATION' }
            th { 'GAIN' }
            #th { 'PORTFOLIO ?' }
          end
          day_worst_5.each_with_index do |performance, index|
            tr do
              th :style => cell_style_bold do index + 1 end
              th :style => cell_style do link_to performance.company.name, admin_company_path(performance.company_id) end
              th :style => cell_style do format_variation(performance.gain_and_variation[1]) end
              th :style => cell_style do format_price(performance.gain_and_variation[0]) end
              #th :style => cell_style do end
            end
          end
        end
      end
    end
  end
end