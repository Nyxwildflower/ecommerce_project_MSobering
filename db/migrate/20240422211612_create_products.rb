class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.float :price
      t.integer :stock_quantity
      t.boolean :on_sale

      t.timestamps
    end
  end
end
