require 'test_helper'

class WelcomePageTest < ActionDispatch::IntegrationTest
  test 'test authentication login' do
    get '/dashboard/index'

    assert_response :redirect, 'expecting redirect'
    assert_redirected_to '/users/sign_in', 'to login page'

    assert_not flash[:alert].nil?
    assert_not flash[:alert].empty?
  end
end
