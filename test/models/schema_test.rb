require 'test_helper'

class SchemaTest < ActiveSupport::TestCase
  test 'does not save schema without name' do
    s = schemas(:divadlo)
    s.name = nil
    assert_not s.save
  end

  test 'does not save schema without constraint' do
    s = schemas(:divadlo)
    s.constraint = nil
    assert_not s.save
  end

  test 'does not save schema without capacity' do
    s = schemas(:divadlo)
    s.capacity = nil
    assert_not s.save

    s.capacity = -1
    assert_not s.save
  end

  test 'does not save schema without size' do
    s = schemas(:divadlo)
    s.x = -1
    assert_not s.save

    s.y = -1
    s.x = 10
    assert_not s.save
  end

  test 'does save valid schema' do
    s = schemas(:divadlo)
    assert s.save
  end
end
