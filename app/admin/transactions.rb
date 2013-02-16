ActiveAdmin.register Transaction do

  menu :parent => 'Orders'

  config.sort_order = :created_at_desc

  filter :created_at

  index :download_links => false do
    column(:executed_at) { |transaction| link_to format_date(transaction.created_at), admin_transaction_path(transaction) }
    column(:amount)      { |transaction| format_price_with_sign(transaction.amount_signed) }
  end

  show do |company|
    attributes_table do
      row(:type)       { |transaction| Transaction::TYPES[transaction.transaction_type].to_s.titleize }
      row(:amount)     { |transaction| format_price_with_sign(transaction.amount, { :right_align => false }) }
      row(:created_at) { |transaction| format_date(transaction.created_at) }
    end
  end

end