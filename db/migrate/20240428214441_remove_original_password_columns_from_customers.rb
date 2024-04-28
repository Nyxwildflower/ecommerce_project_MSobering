class RemoveOriginalPasswordColumnsFromCustomers < ActiveRecord::Migration[7.1]
  def change
    remove_column :customers, :hashed_password, :string
    remove_column :customers, :password_salt, :string
  end
end
