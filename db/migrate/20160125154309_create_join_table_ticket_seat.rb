# M:N Seats - Tickets
class CreateJoinTableTicketSeat < ActiveRecord::Migration
  def change
    create_join_table :tickets, :seats do |t|
      # t.index [:ticket_id, :seat_id]
      # t.index [:seat_id, :ticket_id]
      t.references :ticket, index: true, foreign_key: true
      t.references :seat, index: true, foreign_key: true
    end
  end
end
