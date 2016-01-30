require 'test_helper'
require_relative '../secured/secured_test_case'

class Admin::AdminTestCase < Secured::SecuredTestCase
  def setup
    admin_login
  end
end
