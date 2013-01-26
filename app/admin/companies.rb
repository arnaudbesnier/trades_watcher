ActiveAdmin.register Company do

  config.sort_order = :name_asc

  filter :symbol

  index :download_links => false do
    column :name
    column(:symbol)        { |company| link_to company.symbol, admin_company_path(company) }
    column(:sector)        { |company| company.sector.name.upcase if company.sector }
    column(:current_value) { |company| company.quotes.any? ? format_price(company.quotes.last.value) : nil }
  end

  show do |company|
    attributes_table do
      row :name
      row :symbol
      row(:sector)        { |company| company.sector.name.upcase }
      row(:current_value) { |company| company.quotes.any? ? format_price(company.quotes.last.value) : nil }
    end
  end

end