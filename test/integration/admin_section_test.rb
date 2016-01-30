require 'test_helper'

class AdminSectionTest < ActionDispatch::IntegrationTest
  test 'user authorization' do
    user = login(:user)

    user.browses '/' do
      assert_response :success
      assert assigns(:schemas)
    end

    user.browses '/admin' do
      assert_response :redirect, 'expecting redirect'
      assert_redirected_to '/', 'to home page'

      assert_not flash[:alert].nil?
      assert_not flash[:alert].empty?
    end
    # assert_response :redirect, 'expecting redirect'
  end

  test 'admin authorization' do
    admin = login(:admin)

    admin.browses '/' do
      assert_response :success
    end

    admin.browses '/admin' do
      assert_response :success
      assert assigns(:schemas)
    end
  end

  private

  module Custom
    def browses(url, a = nil, &block)
      get url, a, 'HTTP_REFERER' => '/'
      instance_eval(&block)
    end
  end

  def login(user)
    open_session do |sess|
      sess.extend(Custom)
      u = users(user)
      sess.https!
      sess.post_via_redirect '/users/sign_in', user: { email: u.email,
                                                       password: '123456' }
      assert_equal '/', sess.path
      sess.https!(false)
    end
  end
end
