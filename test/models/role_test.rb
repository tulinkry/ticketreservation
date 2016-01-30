require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test 'should not save role without name' do
    role = Role.new
    assert_not role.save
  end

  test 'role name should be either admin or user' do
    role = Role.new
    role.name = 'user'
    assert role.save

    role.name = 'admin'
    assert role.save

    role.name = 'admin1'
    assert_not role.save
  end
end
