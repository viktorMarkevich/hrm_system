# coding: utf-8

class StickersController < ApplicationController
  load_and_authorize_resource param_method: :sticker_params

  include Events
  include VacancyAction

  before_filter :authenticate_user!
  before_filter :find_sticker, only: [:update, :edit, :destroy, :show, :status_sticker]
  before_filter :prepare_performers, only: [:new, :edit, :create]

  def index
    @stickers = Sticker.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(8)
    @stickers = @stickers.where('performer_id = ?', "#{current_user.id}") unless current_user.is_director?
  end

  def new
    @sticker = Sticker.new
  end

  def show
  end

  def edit
  end

  def create
    @sticker = current_user.owner_stickers.build(sticker_params)
    if @sticker.save
      flash[:notice] = 'Стикер был успешно создан.'
      redirect_to stickers_path
    else
      render 'new'
    end
  end

  def update
    if @sticker.update(sticker_params)
      NoticeMailer.notice_of_appointment(@sticker).deliver_now if @sticker.previous_changes[:performer_id] && @sticker.performer_id && @sticker.status == 'Назначен'
      @sticker.destroy if @sticker.status == 'Закрыт'
      flash[:notice] = 'Стикер был успешно обновлен.'
      redirect_to stickers_path
    else
      render 'edit'
    end
  end

  def destroy
    if @sticker.destroy
      flash[:notice] = 'Стикер был успешно закрыт.'
      redirect_to stickers_path
    end
  end

  def status_sticker
    status = params[:sticker][:status]
    NoticeMailer.sticker_closed(@sticker).deliver_now if status == 'Выполнен'
    @sticker.update(status: status, progress: params[:sticker][:progress])
    @sticker.destroy if status == 'Закрыт'
    redirect_to stickers_path
  end

  private
   def sticker_params
     params.require(:sticker).permit(:description, :performer_id, :status, :progress)
   end

   def find_sticker
     @sticker = Sticker.find(params[:id])
   end

   def prepare_performers
     @performers = User.get_performers
   end

end