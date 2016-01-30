require 'test_helper'
require_relative 'base_controller_test'

class Secured::DashboardControllerTest < Secured::SecuredTestCase
  
  test 'should get index' do
    get :index
    assert_response :success

    assert_not_nil assigns(:schemas), 'Should return schemas'
    assert assigns(:schemas).count > 0, 'Should return some schemas'
    assert_not_nil assigns(:orders), 'Should return orders'
    assert_not_nil assigns(:tickets), 'Should return tickets'
  end
end
