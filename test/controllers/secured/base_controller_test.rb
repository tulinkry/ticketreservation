require 'test_helper'
require_relative 'secured_test_case'

class Secured::BaseControllerTest < Secured::SecuredTestCase


  test 'does not add a reserved seat' do
    seat = seats(:seat_10_10)
    seat.state = Seat::RESERVED
    seat.save!

    post :virtual_ticket_add_seat, seat: seat

    assert assigns(:virtual_ticket).seats.size == 0, 'Does not add a seat'
    assert session[:seats].nil? || session[:seats].size == 0, 'does not add to the session'

    assert_response :redirect
    assert_not flash[:alert].empty?, 'Triggers an error'
    assert_redirected_to schema_path(seat.schema), 'fails to insert and redirects'
  end

  test 'does not add an invalid seat' do
    seat = seats(:seat_10_10)
    seat.state = Seat::WALL
    seat.save!

    post :virtual_ticket_add_seat, seat: seat

    assert assigns(:virtual_ticket).seats.size == 0, 'Does not add a seat'
    assert session[:seats].nil? || session[:seats].size == 0, 'does not add to the session'

    assert_response :redirect
    assert_not flash[:alert].empty?, 'Triggers an error'
    assert_redirected_to schema_path(seat.schema), 'fails to insert and redirects'
  end

  test 'does add a seat' do
    seat = seats(:seat_10_10)

    post :virtual_ticket_add_seat, seat: seat

    assert assigns(:virtual_ticket).seats.size > 0, 'does add the seat'
    assert !session[:seats].nil? && session['seats'].size > 0, 'seats are stored in session'

    assert_response :redirect
    assert flash[:alert].nil?, 'Does not trigger an error'
    assert_redirected_to schema_path(seat.schema), 'redirects'
  end

  test 'does not add a seat from different deck' do
    seat = seats(:seat_for_koncert)

    post :virtual_ticket_add_seat, { seat: seat }, seats: [seats(:seat_10_10).id]

    assert assigns(:virtual_ticket).seats.size == 1, 'Does not add a seat'
    assert !session[:seats].nil? && session[:seats].size == 1, 'does not add to the session'

    assert_response :redirect
    assert_not flash[:alert].empty?, 'Triggers an error'
    assert_redirected_to schema_path(seat.schema), 'fails to insert and redirects'
  end

  test 'can not delete non existing seat' do
    seat = seats(:seat_5_5)

    post :virtual_ticket_delete_seat, { seat: seat }, seats: [seats(:seat_10_10).id]

    assert assigns(:virtual_ticket).seats.size == 1, 'Does not delete a seat'
    assert !session[:seats].nil? && session[:seats].size == 1, 'does not delete from the session'
    assert_response :redirect
    assert_redirected_to schema_path(seat.schema), 'fails to insert and redirects'
  end

  test 'delete a seat' do
    seat = seats(:seat_10_10)

    post :virtual_ticket_delete_seat, { seat: seat }, seats: [seats(:seat_10_10).id]

    assert assigns(:virtual_ticket).seats.size == 0, 'does delete a seat'
    assert session[:seats].nil? || session[:seats].size == 0, 'does delete the session'

    assert_response :redirect
    assert flash[:alert].nil?, 'does not trigger an error'
    assert_redirected_to schema_path(seat.schema), 'redirects'
  end

  test 'close ticket' do
    seat = seats(:seat_10_10)

    tickets_cnt = Ticket.count

    post :virtual_ticket_close, nil, seats: [seats(:seat_10_10).id]

    assert session[:seats].nil? || session[:seats].size == 0, 'clears the session'
    assert_response :redirect

    assert flash[:alert].nil?, 'does not trigger an error'
    assert_redirected_to tickets_path, 'redirects'

    assert Ticket.count > tickets_cnt, 'adds the ticket'
  end
end
