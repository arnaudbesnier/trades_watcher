ActiveAdmin.register Quote do

	config.sort_order = :company_id_asc

	filter :company

	index :download_links => false do
		column(:company)         { |quote| quote.company.name }
    	column :value
    	column :variation_day_current
    	column :volume
    	column :value_day_open
    	column(:values_day)      { |quote| "#{quote.value_day_low} - #{quote.value_day_high}"}
    	column(:variations_day)  { |quote| "#{quote.variation_day_low} - #{quote.variation_day_high}"}
    	column :created_at
    	#column(:price_bought) { |t| format_price(t.price_bought) }
    	#column(:price_sold)   { |t| format_price(t.price_sold) }
    	#column(:closed_at)    { |t| format_datetime(t.closed_at) }
    	#column(:fees)         { |t| format_price(t.total_fees) }
    	#column(:gains)        { |t| "#{format_price(t.gain)} (#{t.performance})" if t.gain }
  	end

end