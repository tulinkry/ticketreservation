class Secured::SeatsController < Secured::BaseController
  before_action :set_seat, only: [:destroy]

  # DELETE /seats/1
  # DELETE /seats/1.json
  def destroy

    @ticket.seats.delete(@seat)

    @seat.state = ::Seat::AVAILABLE
    @seat.save!

    if @ticket.seats.size == 0
      @ticket.destroy!
      respond_to do |format|
        format.html { redirect_to tickets_path, notice: 'Seat was successfully destroyed.' }
        format.json { head :no_content }
      end

      return
    end

    @ticket.save!

    respond_to do |format|
      format.html { redirect_to ticket_path(@ticket), notice: 'Seat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seat
      @seat = ::Seat.find(params[:id])
      @ticket = ::Ticket.find(params[:ticket_id])
    end

end
