ActiveAdmin.register Order do

  filter :order_type
  filter :company_id
  filter :created_at

  index :download_links => false do
  end

  show do |company|
    attributes_table do
    end
  end

end