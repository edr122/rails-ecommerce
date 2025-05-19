class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :total_amount, precision: 10, scale: 2
      t.datetime :purchased_at

      t.timestamps
    end
  end
end
