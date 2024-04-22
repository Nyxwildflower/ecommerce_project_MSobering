class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.float :gst
      t.float :pst
      t.float :hst

      t.timestamps
    end
  end
end
