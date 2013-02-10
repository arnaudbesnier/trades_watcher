ActiveAdmin.register Company do
  
  menu :priority => 2

  config.sort_order = :name_asc

  filter :symbol

  index :download_links => false do
    column :name
    column(:symbol)        { |company| link_to company.symbol, admin_company_path(company) }
    column(:sector)        { |company| company.sector.name.upcase if company.sector }
    column(:current_value) { |company| company.quotes.any? ? format_price(company.quotes.last.value) : nil }
    column(:trade_opened)  { |company| check_box_tag 'active', 'yes', company.has_opened_trade?, :disabled => true }
  end

  show do |company|
    attributes_table do
      row :name
      row :symbol
      row(:sector)        { |company| company.sector.name.upcase if company.sector }
      row(:current_value) { |company| company.quotes.any? ? format_price(company.quotes.last.value) : nil }
      row(:trade_opened)  { |company| check_box_tag 'active', 'yes', company.has_opened_trade?, :disabled => true }
    end
  end

end