ActiveAdmin.register Dividend do

  menu :parent => 'Orders'

  config.sort_order = :received_at_desc

  filter :company_id
  filter :received_at

  index :download_links => false do
    column(:company)     { |dividend| link_to dividend.company.name, admin_company_path(dividend.company) }
    column :shares
    column(:amount)      { |dividend| format_price(dividend.amount) }
    column(:total_net)   { |dividend| format_price_with_sign(dividend.total_net) }
    column(:received_at) { |dividend| format_date(dividend.received_at) }
    column('')           { |dividend| show_link_icon(dividend); edit_link_icon(dividend) }
  end

  show do |dividend|
    attributes_table do
      row(:company)     { |dividend| link_to dividend.company.name, admin_company_path(dividend.company) }
      row :shares
      row(:amount)      { |dividend| format_price(dividend.amount, { :right_align => false }) }
      row(:total_net)   { |dividend| format_price_with_sign(dividend.total_net, { :right_align => false }) }
      row(:taxe_rate)   { |dividend| format_percent(dividend.taxes) }
      row(:received_at) { |dividend| format_date(dividend.received_at) }
    end
  end

  form do |f|
    f.inputs "Dividend" do
      f.input :company
      f.input :shares
      f.input :amount
      f.input :taxes
      f.input :received_at, :as => :datetime
    end
    f.buttons
  end

end