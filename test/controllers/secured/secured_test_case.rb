require 'test_helper'
require_relative '../front/front_test_case'

class Secured::SecuredTestCase < Front::FrontTestCase
  def setup
  	user_login
  end

end
