class UserMailer < ApplicationMailer
	default from: 'no-reply@ticketreservation.com'

	def welcome_email(user)
		@user = user
		mail(to: 'tulinkry@localhost', subject: "Welcome #{@user.email}")
	end

	def timeout_email(user, ticket)
		@user = user
		@ticket = ticket
		mail(to: 'tulinkry@localhost', subject: "Your reservation #{ticket.id} was cancelled")
	end

	def new_reservation(user, ticket)
		@user = user
		@ticket = ticket
		mail(to: 'tulinkry@localhost', subject: "Your reservation #{ticket.id} has been received")
	end

	def reservation_cancellation_email(user, ticket, seat)
		@user = user
		@ticket = ticket
		@seat = seat
		mail(to: 'tulinkry@localhost', subject: "Seat on your reservation #{seat.schema.name} was cancelled")
	end
end
