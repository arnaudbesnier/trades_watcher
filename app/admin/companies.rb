ActiveAdmin.register Company do

	config.sort_order = :name_asc

	filter :symbol

	index :download_links => false do
    	column :name
    	column :symbol
  	end

end