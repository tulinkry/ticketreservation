class Front::CronController < Front::BaseController
  def update
  	Ticket.check_older_than(7.day)
  end
end
