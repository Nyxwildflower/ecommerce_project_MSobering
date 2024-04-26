class AddSalesPercentageToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :sale_percentage, :float
  end
end
