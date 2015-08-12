class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :staff_relations, except: [:index, :show]

  # GET /events
  # GET /events.json
  def index
    @events = Event.order(starts_at: :asc)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.build(event_params)
    @event.staff_relation = StaffRelation.find(params[:staff_relation])
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Событие успешно создано.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event.staff_relation = StaffRelation.find(params[:staff_relation])
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Событие успешно обновлено.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Событие успешно удалено.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # def prepare_staff
  #   sr = StaffRelation.find(params[:staff_relation])
  #   sr.event.destroy if sr.event_id != @event.id
  #   @event.staff_relation = sr
  # end

  def staff_relations
    @staff_relations = StaffRelation.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :starts_at, :description)
  end
end