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
		column(:company)      { |trade| link_to trade.company.name, admin_company_path(trade.company_id) }
    	column(:shares)       { |trade| format_integer(trade.shares) }
    	column(:opened_at)    { |trade| link_to format_datetime(trade.opened_at), admin_trade_path(trade.id) }
    	column(:price_bought) { |trade| format_price(trade.price_bought) }
    	column(:price_sold)   { |trade| format_price(trade.price_sold) }
    	column(:closed_at)    { |trade| format_datetime(trade.closed_at) }
    	column(:fees)         { |trade| format_price(trade.total_fees) }
    	column(:gains)        { |trade| format_variation_price(trade.gain, 2, trade.price_sold.nil?) }
    	column(:performance)  { |trade| format_variation(trade.performance, trade.price_sold.nil?) }
  	end

end