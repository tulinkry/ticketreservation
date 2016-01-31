#!/usr/bin/ruby


namespace :ticket do
	task :update => :environment do
		Ticket.check_older_than(7.day)
	end
end