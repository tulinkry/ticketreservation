# Ticket
class Ticket < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :seats

  validates :name, presence: true
  before_destroy :make_seats_available
  before_create :defaults


  def self.check_older_than(day_count)
    begin
      Ticket.transaction do
        tickets = Ticket.where('created_at < ? AND confirmed = 0', DateTime.now - day_count)
        tickets.each do |ticket|
          UserMailer.timeout_email(ticket.user, ticket).deliver_now
          ticket.destroy!
        end
      end
    rescue Exception => e
      raise e
    end
  end

  private
  def make_seats_available
  	seats.each do |seat|
  		seat.available!
  		seat.save!
  	end
  end

  def defaults
    self.confirmed ||= 0
  end
end
