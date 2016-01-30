require 'test_helper'
require_relative 'base_controller_test'

class Secured::SchemasControllerTest < Secured::SecuredTestCase
  def setup
    super
    @schema = schemas(:divadlo)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schemas)
  end


  test "should show schema" do
    get :show, id: @schema
    assert_response :success

    assert_equal @schema, assigns(:schema)
    assert_not_nil assigns(:current_user_seats)
  end


  test 'should get show with correct seats' do
    get :show, id: @schema
    assert_response :success

    assert @schema.seat_map.size == assigns(:schema).seat_map.size, 'Equal number of seats'

    assert assigns(:schema).seat_map.size == @schema.y, 'Row length is equal'

    assigns(:schema).seat_map.each do |row|
      assert row.size == @schema.x, 'Column length is equal'
      row.each do |seat|
        assert_includes @schema.seats, seat, 'A seat should be included in the original set'
      end
    end
  end


end
