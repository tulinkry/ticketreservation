# Seat
class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :x
      t.integer :y

      t.integer :state

      t.references :schema, index: true, foreign_key: true
      t.integer :price

      t.timestamps null: false
    end
  end
end
