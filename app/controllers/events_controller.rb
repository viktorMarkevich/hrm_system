class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :set_sr, only: [:new, :edit]
  before_action :set_date
  before_action :set_events_current_month, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @event = Event.new
    respond_to do |format|
      format.html { render nothing: true }
      format.js
    end
  end

  def edit
  end

  def create
    @event = current_user.events.build(event_params)
    set_event_sr if params[:event][:staff_relation].to_i != 0
    respond_to do |format|
      if @event.save
        set_events_current_month
        format.js
      else
        format.json { render json: @event.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def update
    set_event_sr if params[:event][:staff_relation].to_i != 0
    respond_to do |format|
      if @event.update(event_params)
        set_events_current_month
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
    @staff_relations = StaffRelation.where('status IN (?) and event_id IS NOT NULL', ['Собеседование', 'Утвержден'])
  end

  def set_date
    @date = params[:start_date].try(:to_date) || DateTime.now
    @the_exact_date = params[:the_exact_date]
  end

  def event_params
    params.require(:event).permit(:name, :will_begin_at, :description, :user_id)
  end

  def set_events_current_month
    @events = Event.events_current_month(@date, @the_exact_date, current_user).order(will_begin_at: :asc)
  end
end