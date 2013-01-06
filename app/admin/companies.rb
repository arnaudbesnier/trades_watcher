ActiveAdmin.register Company do

	filter :symbol

	index :download_links => false do
    	column :name
    	column :symbol
  	end

end