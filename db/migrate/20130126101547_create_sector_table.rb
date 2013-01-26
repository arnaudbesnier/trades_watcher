class CreateSectorTable < ActiveRecord::Migration
  def up
    create_table :sectors do |t|
      t.string :name
    end
    add_column :companies, :sector_id, :integer
  end

  def down
    drop_table :sectors
  end
end
