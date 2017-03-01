class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :set_sr, only: [:new, :edit]
  before_action :set_date
  before_action :set_events_in_date_period, only: [:index, :update]

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @event = Event.new
    set_events_in_date_period
    respond_to do |format|
      format.html {  head :ok  }
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html { head :ok }
      format.js
    end
  end

  def create
    @event = current_user.events.build(event_params)
    set_event_sr if params[:event][:staff_relation].to_i != 0
    respond_to do |format|
      if @event.save
        set_events_in_date_period
        format.js
      else
        set_events_in_date_period
        format.json { render json: @event.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def update
    set_event_sr if params[:event][:staff_relation].to_i != 0
    respond_to do |format|
      if @event.update(event_params)
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

  def set_event_sr
    sr = StaffRelation.find(params[:event][:staff_relation])
    @event.staff_relation = sr
    @event.name = sr.status
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_sr
    @staff_relations = StaffRelation.get_without_event
  end

  def set_date
    if params[:start_date].present?
      @date_from = Time.zone.parse(params[:start_date])
      @date_to = @date_from.end_of_month
    else
      @date_from = Time.zone.now
      @date_to = @date_from.end_of_month
    end
  end

  def event_params
    params.require(:event).permit(:name, :will_begin_at, :description, :user_id)
  end

  def set_events_in_date_period
    @events = Event.events_of(current_user, @date_from, @date_to).order(will_begin_at: :asc)
    @events_month = Event.events_of(current_user, @date_from.beginning_of_month, @date_to).order(will_begin_at: :asc)
    @events_past = Event.events_of(current_user, @date_from.beginning_of_month, @date_from).order(will_begin_at: :asc)
  end
end