class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :set_sr, only: [ :edit]
  before_action :set_date, only: [:index, :edit, :update, :destroy]
  before_action :set_events_in_date_period, only: [:index, :update]
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.html
      format.json { render :index }
    end
  end
  def show
    @event= Event.find(params[:id])
    render json: {e: @event, v: @event.staff_relation.vacancy, c: @event.staff_relation.candidate}
  end

  def selected_day_events
    @events = Event.where("DATE(will_begin_at) =  ?", params[:will_begin_at].to_date)
  end

  def edit
  end

  def create
    @vacancies=Vacancy.all
    @event = current_user.events.build(event_params)
    set_event_sr if params[:event][:staff_relation].to_i != 0
    respond_to do |format|
      if @event.save
        format.html { flash[:notice] = 'Event created!' }
        format.json { render @event, status: :created }
      else
        format.html { flash[:danger] = @event.errors.full_messages }
        format.json { render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_event_sr if params[:event][:staff_relation]
    @event.update(event_params)
    p @event.will_begin_at
    render json: {e: @event, v: @event.staff_relation.vacancy, c: @event.staff_relation.candidate}
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Событие успешно удалено.' }
      format.json
    end
  end

  private

  def set_event_sr
    @staff_relation = StaffRelation.find_or_create_by(candidate_id: params[:event][:staff_relation][:candidate_id], vacancy_id: params[:event][:staff_relation][:vacancy_id] )
    @event.update(staff_relation_id: @staff_relation.id )

  end

  def set_event
    @event = Event.find(params[:id])
  end

  def set_sr
    @staff_relations = StaffRelation.get_without_event
  end

  def set_date
    @date_from = Time.zone.parse(params[:start_date].to_s) || Time.zone.now
    @date_from = @date_from.beginning_of_month if @date_from > Time.zone.now
    @date_to = @date_from.end_of_month
  end

  def event_params
    permitted_params = params.require(:event).permit(:name, :will_begin_at, :description, :user_id, staff_relation_attributes: [:vacancy_id, :candidate_id])
    permitted_params&.tap {|p| p[:will_begin_at] = (params[:event][:will_begin_at]).to_datetime }
  end

  def set_events_in_date_period
    @events = Event.events_of(current_user, @date_from, @date_to).includes(:staff_relation).order(will_begin_at: :asc)
    @events_month = Event.events_of(current_user, @date_from.beginning_of_month, @date_to).order(will_begin_at: :asc)
    @events_past = Event.events_of(current_user, @date_from.beginning_of_month, Time.zone.now.advance(minutes: -1)).includes(:staff_relation).order(will_begin_at: :asc)
  end
end