# Schema
class CreateSchemas < ActiveRecord::Migration
  def change
    create_table :schemas do |t|
      t.string :name
      t.integer :capacity
      t.integer :x
      t.integer :y
      t.text	:schema
      t.integer :constraint

      t.timestamps null: false
    end
  end
end
