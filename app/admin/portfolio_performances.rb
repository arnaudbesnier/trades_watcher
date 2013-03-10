ActiveAdmin.register PortfolioPerformance do

  menu :parent => 'Trades', :label => 'Performances'

  config.sort_order = :created_at_asc

  actions :index

  index :download_links => false do
    column(:value_open)  { |day_perf| format_price(day_perf.value_open) }
    column(:value_close) { |day_perf| format_price(day_perf.value_close) }
    column(:trade_gains) { |day_perf| format_price(day_perf.trade_gains) }
    column(:closings)    { |day_perf| format_integer(day_perf.closings) }
    column(:closed_at)   { |day_perf| format_datetime(day_perf.closed_at) }
  end
end