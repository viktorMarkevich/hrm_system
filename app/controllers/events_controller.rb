class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :set_sr, only: [:new, :edit]

  def index
    @date = params[:start_date].to_date || DateTime.now
    @events = Event.events_current_month(@date).order(starts_at: :asc)
  end

  def new
    @date = params[:start_date].to_date || DateTime.now
    @event = Event.new
  end

  def edit
    @date = params[:start_date].to_date || DateTime.now
  end

  def create
    @event = current_user.events.build(event_params)
    @event.staff_relation = StaffRelation.find(params[:event][:staff_relation]) if params[:event][:staff_relation]
    respond_to do |format|
      if @event.save
        @events = Event.order(starts_at: :asc)
        format.js
      else
        format.json { render json: @event.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def update
    @event.staff_relation = StaffRelation.find(params[:event][:staff_relation]) if params[:event][:staff_relation]
    respond_to do |format|
      if @event.update(event_params)
        @events = Event.order(starts_at: :asc)
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @event.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.staff_relation.update(event_id: nil) if @event.staff_relation
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Событие успешно удалено.' }
      format.json { head :no_content }
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_sr
    @staff_relations = StaffRelation.all
  end

  def event_params
    params.require(:event).permit(:name, :starts_at, :description)
  end
end