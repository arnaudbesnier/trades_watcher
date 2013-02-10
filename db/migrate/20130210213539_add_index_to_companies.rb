class AddIndexToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :index, :string
  end
end
