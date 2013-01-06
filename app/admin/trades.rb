include ApplicationHelper

ActiveAdmin.register Trade do

	scope :opened
	scope :closed

	filter :company
	filter :opened_at
	filter :closed_at

	index :download_links => false do
		column(:company)          { |t| t.company.name }
    	column :shares
    	column(:opened_at)        { |t| format_datetime(t.opened_at) }
    	column(:price_bought)     { |t| format_price(t.price_bought) }
    	column(:total_bought)     { |t| format_price(t.total_bought) }
    	column(:closed_at)        { |t| format_datetime(t.closed_at) }
    	column(:price_sold)       { |t| format_price(t.price_sold) }
    	column(:total_sold)       { |t| format_price(t.total_sold) }
    	column(:commission_total) { |t| format_price(t.commission_total) }
    	column(:taxes)            { |t| format_price(t.taxes) }
  	end

end