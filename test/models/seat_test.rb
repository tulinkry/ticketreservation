require 'test_helper'

class SeatTest < ActiveSupport::TestCase
  test 'does not save seat without position' do
    s = seats(:seat_for_koncert)
    s.schema = Schema.first
    s.x = -1
    assert_not s.save

    s.y = -1
    s.y = 10
    assert_not s.save
  end
end
