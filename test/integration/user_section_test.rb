require 'test_helper'

class UserSectionTest < ActionDispatch::IntegrationTest
  test 'test login form' do
    get '/users/sign_in'
    assert_response :success

    post_via_redirect '/users/sign_in', user: { 'email' => users(:user).email,
                                                'password' => '123456' }

    assert_equal '/', path
    assert_not flash[:notice].nil?
    assert_not flash[:notice].empty?

    assert assigns(:schemas)
  end
end
