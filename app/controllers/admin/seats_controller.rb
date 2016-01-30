class Admin::SeatsController < Admin::BaseController
  before_action :set_seat, only: [:change_state]

  def change_state
    was_reserved = false

    if @seat.reserved? && @seat.tickets.count > 0
      ticket = @seat.tickets.first
      ticket.seats.delete(@seat)
      was_reserved = true
    end

    state = case @seat.state
    when ::Seat::AVAILABLE
      ::Seat::RESERVED
    when ::Seat::RESERVED
      @schema.capacity -= 1
      ::Seat::WALL
    when ::Seat::WALL
      @schema.capacity += 1
      ::Seat::AVAILABLE
    else
      ::Seat::WALL
    end


    p = { 'state' => state }
    respond_to do |format|
      begin
        ::Seat.transaction do
          @seat.update!(p)
          @schema.save!
          ticket.save! if was_reserved
          ticket.destroy! if was_reserved && ticket.seats.size <= 0
        end
        UserMailer.reservation_cancellation_email(ticket.user, ticket, @seat).deliver if was_reserved
        format.html { redirect_to admin_schema_path(@schema), notice: 'Seat was successfully updated.' }
        format.json { render :show, status: :ok, location: @seat }
      rescue
        format.html { redirect_to admin_schema_path(@schema), alert: 'Seat could not be changed.' }
        format.json { render json: @seat.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seat
      @seat = ::Seat.find(params[:id])
      @schema = ::Schema.find(params[:schema_id])
    end
end
