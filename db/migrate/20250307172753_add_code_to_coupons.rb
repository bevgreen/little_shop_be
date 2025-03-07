class AddCodeToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :code, :string
    add_index :coupons, :code, unique: true
  end
end
