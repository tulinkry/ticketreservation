require 'test_helper'
require_relative 'base_controller_test'

class Front::CronControllerTest < Front::FrontTestCase 
  test "should get update" do
    get :update
    assert_response :success
  end

end
