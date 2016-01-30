require 'test_helper'
require 'stringio'

class Admin::BaseHelperTest < ActionController::TestCase
  test 'parse basic csv test' do
    schema = Schema.new
    string = "1, 1, 1\n" \
             "2, x, 2\n" \
             "3, x, x\n"
    string = StringIO.new(string)

    csv = ::Admin::BaseHelper::Csv_parser.new(schema)
    csv.parse(string)

    assert_not_nil schema
    assert schema.seats.size == 9, 'should have 9 seats'
    assert schema.seats.to_a.delete_if { |x| !x.available? }.count == 6, 'should have 6 available'
    assert schema.seats.to_a.delete_if(&:available?).count == 3, 'should have 3 closed'
    assert schema.seats.to_a.reduce(0) { |a, e| a + e.price } == 10, 'should have total 10 price'

    assert schema.capacity == 6, 'should be 6 available seats'
    assert schema.x == 3, 'should be max x = 3'
    assert schema.y == 3, 'should be max y = 3'
  end

  test 'parse basic pipe test' do
    schema = Schema.new
    string = "1|1|1\n" \
             "2|x|2\n" \
             "3|x|x\n"
    string = StringIO.new(string)

    pipe = ::Admin::BaseHelper::Pipe_parser.new(schema)
    pipe.parse(string)

    assert_not_nil schema
    assert schema.seats.size == 9, 'should have 9 seats'
    assert schema.seats.to_a.delete_if { |x| !x.available? }.count == 6, 'should have 6 available'
    assert schema.seats.to_a.delete_if(&:available?).count == 3, 'should have 3 closed'
    assert schema.seats.to_a.reduce(0) { |a, e| a + e.price } == 10, 'should have total 10 price'

    assert schema.capacity == 6, 'should be 6 available seats'
    assert schema.x == 3, 'should be max x = 3'
    assert schema.y == 3, 'should be max y = 3'
  end
end
