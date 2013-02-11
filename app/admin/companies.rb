ActiveAdmin.register Company do
  
  menu :priority => 2

  config.sort_order = :name_asc

  filter :symbol

  scope :portfolio
  scope 'CAC40'
  scope 'SBF120'

  index :download_links => false do
    column :name
    column(:symbol)        { |company| link_to company.symbol, admin_company_path(company) }
    column(:sector)        { |company| company.sector.name.upcase if company.sector }
    column(:index)         { |company| company.index.upcase }
    column(:current_value) { |company| company.quotes.any? ? format_price(company.quotes.last.value) : nil }
    column(:trade_opened)  { |company| check_box_tag 'active', 'yes', company.has_opened_trade?, :disabled => true }
  end

  show do |company|
    attributes_table do
      row :name
      row :symbol
      row(:sector)        { |company| company.sector.name.upcase if company.sector }
      row(:index)         { |company| company.index.upcase }
      row(:current_value) { |company| company.quotes.any? ? format_price(company.quotes.last.value, { :right_align => false }) : nil }
      row(:trade_opened)  { |company| check_box_tag 'active', 'yes', company.has_opened_trade?, :disabled => true }
    end
  end

end