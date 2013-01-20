ActiveAdmin.register Transaction do

  config.sort_order = :created_at_desc

  filter :created_at

  index :download_links => false do
    column(:type)       { |transaction| Transaction::TYPES[transaction.transaction_type].to_s.titleize }
    column(:amount)     { |transaction| format_price(transaction.amount) }
    column(:created_at) { |transaction| link_to format_date(transaction.created_at), admin_transaction_path(transaction) }
  end

  show do |company|
    attributes_table do
      row(:type)       { |transaction| Transaction::TYPES[transaction.transaction_type].to_s.titleize }
      row(:amount)     { |transaction| format_price(transaction.amount, { :right_align => false }) }
      row(:created_at) { |transaction| format_date(transaction.created_at) }
    end
  end

end