include ApplicationHelper

ActiveAdmin.register Trade do

	scope :all
	scope :opened
	scope :closed

	filter :company
	filter :opened_at
	filter :closed_at

	index :download_links => false do
		column(:company)      { |t| t.company.name }
    	column :shares
    	column(:opened_at)    { |t| format_datetime(t.opened_at) }
    	column(:price_bought) { |t| format_price(t.price_bought) }
    	column(:total_bought) { |t| format_price(t.total_bought) }
    	column(:closed_at)    { |t| format_datetime(t.closed_at) }
    	column(:price_sold)   { |t| format_price(t.price_sold) }
    	column(:total_sold)   { |t| format_price(t.total_sold) }
    	column(:fees)         { |t| format_price(t.total_fees) }
    	column(:gains)        { |t| format_price(t.gain) }
  	end

end