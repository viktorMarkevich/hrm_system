class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    @events = Event.order(starts_at: :asc)
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        @events = Event.order(starts_at: :asc)
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @event.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def update
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


  def event_params
    params.require(:event).permit(:name, :starts_at, :description)
  end
end