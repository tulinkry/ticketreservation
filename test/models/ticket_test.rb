require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  test 'should not save ticket without name' do
    ticket = Ticket.new
    assert_not ticket.save
  end
end
