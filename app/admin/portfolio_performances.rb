ActiveAdmin.register PortfolioPerformance do

  menu :parent => 'Trades', :label => 'Performances'

  config.sort_order = :created_at_asc

  actions :index

end