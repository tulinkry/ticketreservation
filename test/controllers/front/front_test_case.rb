require 'test_helper'

class Front::FrontTestCase < ActionController::TestCase
  include Devise::TestHelpers

  def user_login
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in users(:user)
  end

  def admin_login
    @request.env['devise.mapping'] = Devise.mappings[:admin]
    sign_in users(:admin)
  end
end
