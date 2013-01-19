ActiveAdmin.register Dividend do

  config.sort_order = :received_at_desc

  filter :company_id
  filter :received_at

end