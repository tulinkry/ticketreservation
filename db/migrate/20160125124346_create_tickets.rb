# Ticket
class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.boolean :confirmed

      t.timestamps null: false
    end
  end
end
