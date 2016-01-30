class Admin::BaseController < Secured::BaseController
  before_action :admin_only!


  private

  def admin_only!
    redirect_to '/', alert: 'You are not allowed to see this page' unless current_user.try(:admin?)
  end
end
