ActiveAdmin.register Transaction do

  menu :parent => 'Orders'

  config.sort_order = :created_at_desc

  filter :created_at

  index :download_links => false do
    column(:executed_at) { |transaction| format_date(transaction.created_at) }
    column(:amount)      { |transaction| format_price_with_sign(transaction.amount) }
    column('')           { |transaction| show_link_icon(transaction); edit_link_icon(transaction) }
  end

  show do |company|
    attributes_table do
      row(:type)       { |transaction| Transaction::TYPES[transaction.transaction_type].to_s.titleize }
      row(:amount)     { |transaction| format_price_with_sign(transaction.amount, { :right_align => false }) }
      row(:created_at) { |transaction| format_date(transaction.created_at) }
    end
  end

    form do |f|
    f.inputs "Order" do
      f.input :transaction_type,  :as => :select, :include_blank => false, :collection => Transaction::TYPE_IDS
      f.input :amount
      f.input :created_at,  :as => :datetime
    end
    f.buttons
  end

end