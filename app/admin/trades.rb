include ApplicationHelper

ActiveAdmin.register Trade do

  menu :priority => 2

  config.sort_order = :updated_at_desc

  scope :all
  scope :opened
  scope :closed

  filter :company

  index :download_links => false do
    column(:company)     { |trade| link_to trade.company.name, admin_company_path(trade.company_id) }
    column(:shares)      { |trade| format_integer(trade.shares) }
    column(:opened_at)   { |trade| link_to format_datetime(trade.order_open.executed_at), admin_trade_path(trade.id) }
    column(:bought)      { |trade| format_price(trade.order_open.value) }
    column(:sold)        { |trade| format_price(trade.sold_value) }
    column(:closed_at)   { |trade| format_datetime(trade.order_close.executed_at) if trade.order_close }
    column(:fees)        { |trade| format_price(trade.total_fees) }
    column(:gains)       { |trade| format_variation_price(trade.gain, { :highlight => trade.order_close.nil? }) }
    column(:performance) { |trade| format_variation(trade.performance, { :highlight => trade.order_close.nil? }) }
  end

  show do |trade|
    attributes_table do
      row(:company)     { |trade| link_to trade.company.name, admin_company_path(trade.company_id) }
      row(:shares)      { |trade| format_integer(trade.shares, { :right_align => false }) }
      row(:opened_at)   { |trade| format_datetime(trade.order_open.executed_at) }
      row(:bought)      { |trade| format_price(trade.order_open.value, { :right_align => false }) }
      row(:sold)        { |trade| format_price(trade.sold_value, { :right_align => false }) }
      row(:closed_at)   { |trade| format_datetime(trade.order_close.executed_at) if trade.order_close }
      row(:fees)        { |trade| format_price(trade.total_fees, { :right_align => false }) }
      row(:gains)       { |trade| format_variation_price(trade.gain, { :right_align => false }) }
      row(:performance) { |trade| format_variation(trade.performance, { :right_align => false }) }
    end
  end

end