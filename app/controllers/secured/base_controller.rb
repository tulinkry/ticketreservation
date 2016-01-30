class Secured::BaseController < Front::BaseController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :unserialize_ticket


  # Saves the virtual ticket to the database and clears the session
  def virtual_ticket_close
    redirect_to(home_path) && return if @virtual_ticket.seats.size == 0

    @virtual_ticket.name = @virtual_ticket.seats.first.schema.name
    @virtual_ticket.user = current_user

    if @virtual_ticket.seats.any? { |s| !s.available? }
      flash[:alert] = "You can't be assigned to a reserved place!"
      redirect_to(schema_path(@virtual_ticket.seats.first.schema)) && return
    end

    total_seats = current_user.orders
                  .where('`schemas`.id = ?', @virtual_ticket.seats.first.schema)
                  .reduce(0) { |a, e| a + e['total'] } + @virtual_ticket.seats.size
    if total_seats > @virtual_ticket.seats.first.schema.constraint
      flash[:alert] = "You can't have more seats than limit #{@virtual_ticket.seats.first.schema.constraint}"
      redirect_to(schema_path(@virtual_ticket.seats.first.schema)) && return
    end

    begin
      ::Ticket.transaction do
        @virtual_ticket.seats.each do |s|
          s.state = ::Seat::RESERVED
          s.save!
        end

        @virtual_ticket.save!
      end
  	  UserMailer.new_reservation(current_user, @virtual_ticket).deliver_now
  	  session['seats'] = []
  	  redirect_to tickets_path, :notice => 'Ticket saved!'
    rescue Exception => e
      flash[:alert] = 'Process failed while it was saving the data, try to repeat the action or contact administrator!'
      redirect_to(schema_path(params[:id])) && return
    end


  end

  # Deletes a particular seat from the virtual ticket
  def virtual_ticket_delete_seat
    seat = ::Seat.find(params[:seat])

    @virtual_ticket.seats.delete(seat) if @virtual_ticket.seats.include?(seat)

    session['seats'] = @virtual_ticket.seats.map(&:id)

    redirect_to schema_path(seat.schema)
  end

  # Adds a particular seat to the virtual ticket
  def virtual_ticket_add_seat
    seat = ::Seat.find(params[:seat])

    if @virtual_ticket.seats.size + 1 > seat.schema.constraint
      flash[:alert] = "You can't have more seats than limit #{seat.schema.constraint}"
      redirect_to(schema_path(seat.schema)) && return
    end

    unless seat.available?
      flash[:alert] = "You can't be assigned to a reserved place"
      redirect_to(schema_path(seat.schema)) && return
    end

    if @virtual_ticket.seats.any? { |x| x.schema != seat.schema }
      flash[:alert] = "You can't add a place from a different scheme"
      redirect_to(schema_path(seat.schema)) && return
    end

    @virtual_ticket.seats << seat unless @virtual_ticket.seats.include?(seat)

    session['seats'] = @virtual_ticket.seats.map(&:id)

    redirect_to schema_path(seat.schema)
  end


  private
  def unserialize_ticket
    @virtual_ticket = ::Ticket.new

    return unless session.key?('seats') && session['seats'].respond_to?(:map)
    seats = session['seats'].map { |x| ::Seat.find_by_id(x) }.delete_if(&:!)
    @virtual_ticket = ::Ticket.new('user' => current_user, 'seats' => seats)
  end
end
