class Secured::TicketsController < Secured::BaseController
  before_action :set_ticket, only: [:show, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = ::Ticket.all
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = ::Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params[:ticket]
    end
end
