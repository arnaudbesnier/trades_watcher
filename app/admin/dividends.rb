ActiveAdmin.register Dividend do

  menu :parent => 'Orders'

  config.sort_order = :received_at_desc

  filter :company_id
  filter :received_at

  index :download_links => false do
    column(:company)     { |dividend| link_to dividend.company.name, admin_company_path(dividend.company) }
    column :shares
    column(:amount)      { |dividend| format_price(dividend.amount) }
    column(:total_net)   { |dividend| format_variation_price(dividend.total_net) }
    column(:received_at) { |dividend| link_to format_date(dividend.received_at), admin_dividend_path(dividend) }
  end

  show do |dividend|
    attributes_table do
      row(:company)     { |dividend| link_to dividend.company.name, admin_company_path(dividend.company) }
      row :shares
      row(:amount)      { |dividend| format_price(dividend.amount, { :right_align => false }) }
      row(:total_net)   { |dividend| format_variation_price(dividend.total_net, { :right_align => false }) }
      row(:received_at) { |dividend| format_date(dividend.received_at) }
    end
  end

end