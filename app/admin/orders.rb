ActiveAdmin.register Order do

  menu :priority => 3

  config.sort_order = :executed_at_desc

  filter :order_type, :as => :select, :collection => Order::TYPE_IDS
  filter :company_id
  filter :created_at

  scope :all
  scope :executed
  scope :pending

  controller do
    def create
      params[:order] = params[:order].merge(Order.parse_email_data(params[:order][:data])) unless params[:order][:data].blank?
      Order.create!(params[:order])
      redirect_to admin_trades_path
    end
  end

  index :download_links => false do
    column(:company)     { |order| link_to order.company.name, admin_company_path(order.company_id) }
    column(:shares)      { |order| format_integer(order.shares) }
    column(:price)       { |order| format_price(order.price) }
    column(:type)        { |order| format_status(Order::TYPE_NAMES[order.order_type], { :color => Order::TYPE_COLORS[order.order_type] }) }
    column(:commission)  { |order| format_price(order.commission) }
    column(:taxes)       { |order| format_price(order.taxes) if order.send('buy_order?') }
    column(:total)       { |order| format_price(order.total) }
    column(:executed_at) { |order| format_datetime(order.executed_at) if order.executed }
    column('')           { |order| show_link_icon(order); edit_link_icon(order) }
  end

  show do |company|
    attributes_table do
      row(:company)     { |order| link_to order.company.name, admin_company_path(order.company_id) }
      row(:shares)      { |order| format_integer(order.shares, { :right_align => false }) }
      row(:price)       { |order| format_price(order.price, { :right_align => false }) }
      row(:type)        { |order| format_status(Order::TYPE_NAMES[order.order_type], { :color => Order::TYPE_COLORS[order.order_type] }) }
      row(:commission)  { |order| format_price(order.commission, { :right_align => false }) }
      row(:taxes)       { |order| format_price(order.taxes, { :right_align => false }) if order.send('buy_order?') }
      row(:total)       { |order| format_price(order.total, { :right_align => false }) }
      row(:created_at)  { |order| link_to format_datetime(order.created_at), admin_order_path(order.id) }
      row(:executed_at) { |order| link_to format_datetime(order.executed_at), admin_order_path(order.id) if order.executed }
    end
  end

  form do |f|
    f.inputs "Order" do
      f.input :company, :include_blank => false
      f.input :order_type,  :as => :select, :include_blank => false, :collection => Order::TYPE_IDS
      f.input :data, :as => :text
      f.input :shares
      f.input :price
      f.input :commission
      f.input :taxes
      f.input :created_at,  :as => :datetime
      f.input :executed_at, :as => :datetime
    end
    f.actions
  end

end