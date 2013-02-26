ActiveAdmin.register Company do
  
  menu :priority => 4

  actions :index, :show, :edit, :update

  config.sort_order = :name_asc

  filter :symbol

  scope :portfolio
  scope 'CAC40'
  scope 'SBF120'

  index :download_links => false do
    column :name
    column :symbol
    column(:sector)         { |company| company.sector.name.upcase if company.sector }
    column(:index)          { |company| company.index.upcase }
    #column(:day)           do |company|
      #day_performance = Company.cac40_ranking(company)
      #{}"#{format_price_and_variation(day_performance[:gain], day_performance[:performance])} #{day_performance[:rank]}"
    #end
    column(:current_value)  { |company| company.quotes.any? ? format_price(company.last_value) : nil }
    column('Portfolio (%)') { |company| format_percent(company.portfolio_proportion, { :shadow => true }) }
    column(:week_variance)  { |company| format_decimal(company.week_variance) }
    column('')              { |company| show_link_icon(company); edit_link_icon(company) }
  end

  show do |company|
    attributes_table do
      row :name
      row :symbol
      row(:sector)         { |company| company.sector.name.upcase if company.sector }
      row(:index)          { |company| company.index.upcase }
      row(:current_value)  { |company| company.quotes.any? ? format_price(company.last_value, { :right_align => false }) : nil }
      row('Portfolio (%)') { |company| format_percent(company.portfolio_proportion, { :right_align => false }) }
      row(:trade_opened)   { |company| check_box_tag 'active', 'yes', company.has_opened_trade?, :disabled => true }
    end

    chart = GoogleVisualr::Interactive::CandlestickChart.new(company.week_candlechart, candlechart_options)
    div :id => 'chart' do
      render_chart chart, 'chart'
    end
  end

  form do |f|
    f.inputs "Company" do
      f.input :name
      f.input :index
      f.input :sector,  :as => :select, :include_blank => false
    end
    f.buttons
  end

  sidebar :web_links, :only => :show do
    attributes_table_for company do
      row('investir.fr') do
        link_to(tag(:img, :src => asset_path('admin/investir.ico'), :height => 15), "http://bourse.lesechos.fr/bourse/synthese.jsp?code=#{company.symbol}&place=XPAR&codif=MNE", { :target => '_blanc' })
      end
    end
  end

end