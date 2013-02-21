include ApplicationHelper

ActiveAdmin.register Trade do

  menu :priority => 2

  actions :index, :show

  config.sort_order = :updated_at_desc

  scope :all
  scope :opened, :default => true
  scope :closed

  filter :company

  index :download_links => false do
    column(:company,   :sortable => :company_id) { |trade| link_to trade.company.name, admin_company_path(trade.company_id) }
    column(:opened_at, :sortable => :opened_at)  { |trade| format_date(trade.order_open.executed_at) }
    column(:last_price)   { |trade| format_price(trade.company.last_value) }
    column(:day_change)   { |trade| format_price_and_variation(*trade.performance_day) }
    column(:shares)       { |trade| format_integer(trade.shares) }
    column(:bought)       { |trade| format_price(trade.order_open.value) }
    column(:sold)         { |trade| format_price(trade.sold_value) }
    column(:market_value) { |trade| format_price(trade.current_value) }
    column(:gain)         { |trade| format_price_and_variation(trade.gain, trade.performance, { :highlight => trade.opened? }) }
    column('Day\'s Gain') { |trade| format_price_with_sign(trade.gain_day, { :highlight => trade.opened? }) }
    column(:risk_max)     { |trade| format_price_and_variation(trade.max_loss, trade.max_loss_variation) if trade.opened? }
    column('')            { |trade| show_link_icon(trade); }
  end

  show do |trade|
    attributes_table do
      row(:company)      { |trade| link_to trade.company.name, admin_company_path(trade.company_id) }
      row(:opened_at)    { |trade| format_datetime(trade.order_open.executed_at) }
      row(:closed_at)    { |trade| format_datetime(trade.order_close.executed_at) if trade.closed? }
      row(:shares)       { |trade| format_integer(trade.shares, { :right_align => false }) }
      row(:bought)       { |trade| format_price(trade.order_open.value, { :right_align => false }) }
      row(:sold)         { |trade| format_price(trade.sold_value, { :right_align => false }) }
      row(:gains)        { |trade| format_price_and_variation(trade.gain, trade.performance, { :right_align => false }) }
      row(:market_value) { |trade| format_price(trade.current_value, { :right_align => false }) }
    end
  end

  sidebar :current_situation, :only => :index do
    current_performance = Performance.new

    begin_day = Date.today
    end_day   = Date.today + 1.day
    day_performance = Performance.new(begin_day, end_day)

    attributes_table_for current_performance do
      row(:stock_value)  { format_price(current_performance.stock_value) }
      row(:day_gain)     { format_price_and_variation(day_performance.performance_period, day_performance.variation_period) }
      row(:valorization) { format_price(current_performance.valorization) }
      row(:total_gain)   { format_price_and_variation(current_performance.performance_total, current_performance.variation_total) }
      row(:risk_max)     { format_price_and_variation(*Trade.max_loss_and_ratio) }
    end
  end

  sidebar :today, :only => :show do
    attributes_table_for trade do
      row(:last_price)   { |trade| format_price(trade.company.last_value) }
      row(:day_change)   { |trade| format_price_and_variation(*trade.performance_day) }
      row('Day\'s Gain') { |trade| format_price_with_sign(trade.gain_day) }
    end
  end

  sidebar :other, :only => :show do
    attributes_table_for trade do
      row(:fees)     { |trade| format_price(trade.total_fees) }
      row(:risk_max) { |trade| format_price_and_variation(trade.max_loss, trade.max_loss_variation) } if trade.opened?
    end
  end

end