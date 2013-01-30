ActiveAdmin.register Order do

  filter :order_type
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
    column(:taxes)       { |order| format_price(order.taxes) }
    column(:created_at)  { |order| link_to format_datetime(order.created_at), admin_order_path(order.id) }
    column(:executed_at) { |order| link_to format_datetime(order.executed_at), admin_order_path(order.id) if order.executed }
  end

  show do |company|
    attributes_table do
    end
  end

end