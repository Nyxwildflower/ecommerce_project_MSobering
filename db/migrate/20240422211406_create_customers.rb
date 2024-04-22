class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :username
      t.string :hashed_password
      t.string :password_salt
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
