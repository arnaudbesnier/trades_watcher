ActiveAdmin.register Order do

  menu :priority => 3

  config.sort_order = :executed_at_desc

  filter :order_type, :as => :select, :collection => Order::TYPE_IDS
  filter :company_id
  filter :created_at

  scope :all
  scope :executed
  scope :pending

  index :download_links => false do
    column(:company)     { |order| link_to order.company.name, admin_company_path(order.company_id) }
    column(:shares)      { |order| format_integer(order.shares) }
    column(:price)       { |order| format_price(order.price) }
    column(:type)        { |order| format_status(Order::TYPE_NAMES[order.order_type], { :color => Order::TYPE_COLORS[order.order_type] }) }
    column(:commission)  { |order| format_price(order.commission) }
    column(:taxes)       { |order| format_price(order.taxes) if order.order_type == Order::BUY }
    column(:total)       { |order| format_price(order.total) }
    column(:executed_at) { |order| link_to format_datetime(order.executed_at), admin_order_path(order.id) if order.executed }
  end

  show do |company|
    attributes_table do
    row(:company)     { |order| link_to order.company.name, admin_company_path(order.company_id) }
    row(:shares)      { |order| format_integer(order.shares, { :right_align => false }) }
    row(:price)       { |order| format_price(order.price, { :right_align => false }) }
    row(:type)        { |order| format_status(Order::TYPE_NAMES[order.order_type], { :color => Order::TYPE_COLORS[order.order_type] }) }
    row(:commission)  { |order| format_price(order.commission, { :right_align => false }) }
    row(:taxes)       { |order| format_price(order.taxes, { :right_align => false }) if order.order_type == Order::BUY }
    row(:total)       { |order| format_price(order.total) }
    row(:created_at)  { |order| link_to format_datetime(order.created_at), admin_order_path(order.id) }
    row(:executed_at) { |order| link_to format_datetime(order.executed_at), admin_order_path(order.id) if order.executed }
    end
  end

  form do |f|
    f.inputs "Order" do
      f.input :company
      f.input :order_type,  :as => :select, :include_blank => false, :collection => Order::TYPE_IDS
      f.input :shares
      f.input :price
      f.input :commission
      f.input :taxes
      f.input :created_at,  :as => :datetime
      f.input :executed_at, :as => :datetime
    end
    f.buttons
  end

end