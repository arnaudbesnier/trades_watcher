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
		column(:company)      { |trade| trade.company.name }
    	column(:shares)       { |trade| format_integer(trade.shares) }
    	column(:opened_at)    { |trade| format_datetime(trade.opened_at) }
    	column(:price_bought) { |trade| format_price(trade.price_bought) }
    	column(:price_sold)   { |trade| format_price(trade.price_sold) }
    	column(:closed_at)    { |trade| format_datetime(trade.closed_at) }
    	column(:fees)         { |trade| format_price(trade.total_fees) }
    	column(:gains)        { |trade| "#{format_price(trade.gain)} (#{trade.performance})" if trade.gain }
  	end

end