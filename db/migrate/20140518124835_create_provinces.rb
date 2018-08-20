class CreateProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :provinces do |t|
      t.string :name, :unique => true, :null => false
      t.multi_polygon :geom, :srid => 4326
      t.timestamps
    end

    add_index :provinces, :geom,      using: :gist
  end
end
