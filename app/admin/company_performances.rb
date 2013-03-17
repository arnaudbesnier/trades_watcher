ActiveAdmin.register CompanyPerformance do

  menu :parent => 'Companies', :label => 'Performances'

  config.sort_order = :closed_at_desc

  actions :index

  filter :company

  index :download_links => false do
    column(:company)     { |day_perf| link_to day_perf.company.name, admin_company_path(day_perf.company) }
    column(:value_open)  { |day_perf| format_price(day_perf.value_open, { :decimal => 3 }) }
    column(:value_close) { |day_perf| format_price(day_perf.value_close, { :decimal => 3 }) }
    column(:value_low)   { |day_perf| format_price(day_perf.value_low, { :decimal => 3 }) }
    column(:value_high)  { |day_perf| format_price(day_perf.value_high, { :decimal => 3 }) }
    column(:gain)        { |day_perf| format_price_and_variation(*day_perf.gain_and_variation) }
    column(:closed_at)   { |day_perf| format_datetime(day_perf.closed_at) }
  end

end