class Secured::DashboardController < Secured::BaseController
  def index
    @schemas = ::Schema.all
    @orders = current_user.orders
    @tickets = current_user.tickets
  end
end
