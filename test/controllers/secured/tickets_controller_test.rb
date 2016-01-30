require 'test_helper'
require_relative 'base_controller_test'

class Secured::TicketsControllerTest < Secured::SecuredTestCase
  def setup
    super
    @ticket = tickets(:user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)
  end

  test "should show ticket" do
    get :show, id: @ticket
    assert_response :success
  end


  test 'should show ticket details' do
    get :show, id: tickets(:user)
    assert_response :success

    assert_equal tickets(:user), assigns(:ticket)
    assert assigns(:ticket).seats.count > 0, 'Number of seats is greater than zero'
  end  

  test "should destroy ticket" do
    assert_difference('Ticket.count', -1) do
      delete :destroy, id: @ticket
    end

    assert_redirected_to tickets_path
  end
end
