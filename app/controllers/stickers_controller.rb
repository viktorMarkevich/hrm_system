# coding: utf-8

class StickersController < ApplicationController
  load_and_authorize_resource param_method: :sticker_params

  include Events
  include VacancyAction

  before_filter :authenticate_user!
  before_filter :find_sticker, only: [:update, :edit, :destroy, :show]
  before_filter :prepare_performers, only: [:new, :edit, :create]

  def index
    set_stickers
  end

  def new
    @sticker = Sticker.new
  end

  def show
  end

  def edit
  end

  def create
    @sticker = current_user.owner_stickers.build(sticker_params.merge(bg_color: Sticker::BG_COLOR.sample))
    respond_to do |format|
      if @sticker.save
        set_stickers
        NoticeMailer.notice_of_appointment(@sticker).deliver_now if @sticker.performer_id
        flash[:notice] = 'Стикер был успешно создан.'
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @sticker.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sticker.update(sticker_params)
        set_stickers
        NoticeMailer.notice_of_appointment(@sticker).deliver_now if can_send_notifier?
        @sticker.destroy if @sticker.status == 'Закрыт'
        flash[:notice] = 'Стикер был успешно обновлен.'
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @event.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @sticker.is_destroyed?
      set_stickers
      flash[:notice] = 'Стикер был успешно закрыт.'
      respond_to do |format|
        format.js
        format.html { redirect_to stickers_url }
        format.json { head :no_content }
      end
    end
  end

  private

    def set_stickers
      @stickers = Sticker.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(11)
      @stickers = @stickers.where('performer_id = ?', "#{current_user.id}") unless current_user.is_director?
    end

    def can_send_notifier?
      @sticker.previous_changes[:performer_id] &&
          @sticker.performer_id &&
          @sticker.status == 'Назначен'
    end

    def sticker_params
      params.require(:sticker).permit(:description, :performer_id, :status)
    end

    def find_sticker
      @sticker = Sticker.find(params[:id])
    end

    def prepare_performers
      @performers = User.get_performers
    end
end