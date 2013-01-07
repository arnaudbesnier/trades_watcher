include ApplicationHelper

ActiveAdmin.register Trade do

	config.sort_order = :opened_at_asc

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
    	column(:price_sold)   { |t| format_price(t.price_sold) }
    	column(:closed_at)    { |t| format_datetime(t.closed_at) }
    	column(:fees)         { |t| format_price(t.total_fees) }
    	column(:gains)        { |t| "#{format_price(t.gain)} (#{t.performance})" if t.gain }
  	end

end