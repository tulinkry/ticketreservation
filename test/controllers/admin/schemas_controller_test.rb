require 'test_helper'
require_relative 'base_controller_test'


class Admin::SchemasControllerTest < Admin::AdminTestCase
  def setup
    super
    @schema = schemas(:divadlo)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schemas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schema" do
    bulk_txt = fixture_file_upload('test_files/map.txt', 'text/plain')

    cnt = Schema.count

    post :create, schema: { name: 'Koncert blabla',
                           constraint: 10,
                           file: bulk_txt }

    assert_response :redirect

    assert_not_nil assigns(:schema)

    assert Schema.count > cnt, 'Really added'
    assert assigns(:schema).name == 'Koncert blabla', 'Name is equal'
    assert assigns(:schema).constraint == 10, 'Constraint is equal'
    assert assigns(:schema).schema == '140', 'Schema is equal'
    assert assigns(:schema).seats.count == 1, 'Seats are equal'

    assert_redirected_to admin_schema_path(assigns(:schema)), 'Should redirect'
  end

  test 'should post new with form errors' do
    post :new, schema: { name: 'Koncert blabla' }
    assert_response :success

    assert_not_nil assigns(:schema)
  end


  test "should show schema" do
    get :show, id: @schema
    assert_response :success
  end


  test 'should get show with correct seats' do
    get :show, id: @schema
    assert_response :success

    assert @schema.seats.size == assigns(:schema).seats.size, 'Equal number of seats'

    assert assigns(:schema).seat_map.size == @schema.y, 'Row length is equal'

    assigns(:schema).seat_map.each do |row|
      assert row.size == @schema.x, 'Column length is equal'
      row.each do |seat|
        assert_includes @schema.seats, seat, 'A seat should be included in the original set'
      end
    end
  end

  test "should get edit" do
    get :show, id: @schema
    assert_response :success
    assert_not_nil assigns(:schema)

    assert_equal assigns(:schema), @schema
  end

  test 'displays a form for editing' do
    get :edit, id: @schema

    assert_response :success
    assert_not_nil assigns(:schema)
    assert_equal assigns(:schema), @schema
  end

  test 'edit a schema' do
    old = @schema

    put :update, id: @schema,
               schema: { name: 'XYZ',
                         constraint: 5 }

    assert_response :redirect
    assert_not_nil assigns(:schema)

    assert assigns(:schema).name == 'XYZ', 'Name is equal'
    assert assigns(:schema).constraint == 5, 'Constraint is equal'
    assert assigns(:schema).seats.count == old.seats.count, 'Seats are equal'

    assert_redirected_to admin_schema_path(@schema), 'Should redirect'
  end


  # test "should update schema" do
  #   patch :update, id: @schema, schema: {  }
  #   assert_redirected_to schema_path(assigns(:schema))
  # end

  test "should destroy schema" do
    assert_difference('Schema.count', -1) do
      delete :destroy, id: @schema
    end

    assert_redirected_to admin_schemas_path
  end



end
