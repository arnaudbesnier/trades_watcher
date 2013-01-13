ActiveAdmin.register Quote do

	config.sort_order = :company_id_asc

	filter :company

	index :download_links => false do
		column(:company)        { |quote| quote.company.name }
    	column(:value)          { |quote| format_price(quote.value, 3) }
    	column(:variation_day)  { |quote| format_variation(quote.variation_day_current) }
    	column(:volume)         { |quote| format_integer(quote.volume) }
    	column(:value_day_open) { |quote| format_price(quote.value_day_open, 3) }
    	column(:values_day)     { |quote| "#{quote.value_day_low} - #{quote.value_day_high}" }
    	column(:variations_day) { |quote| "#{quote.variation_day_low} - #{quote.variation_day_high}" }
    	column :created_at
  	end

end