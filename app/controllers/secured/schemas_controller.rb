class Secured::SchemasController < Secured::BaseController
  before_action :set_schema, only: [:show]

  # GET /schemas
  # GET /schemas.json
  def index
    @schemas = Schema.all
  end

  # GET /schemas/1
  # GET /schemas/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schema
      @schema = ::Schema.find(params[:id])
      @current_user_seats = current_user.seats
    end
end
