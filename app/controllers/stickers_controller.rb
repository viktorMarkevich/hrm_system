# coding: utf-8

class StickersController < ApplicationController
  load_and_authorize_resource param_method: :sticker_params

  include Events
  include VacancyAction

  before_filter :authenticate_user!
  before_filter :find_sticker, only: [:update, :edit, :destroy, :show]
  before_filter :prepare_performers, only: [:new, :edit, :create]

  def index
    @stickers = Sticker.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(11)
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
    @sticker = current_user.owner_stickers.build(sticker_params.merge(bg_color: Sticker::BG_COLOR.sample))
    respond_to do |format|
      if @sticker.save
        @stickers = Sticker.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(11)
        @stickers = @stickers.where('performer_id = ?', "#{current_user.id}") unless current_user.is_director?
        # NoticeMailer.notice_of_appointment(@sticker).deliver_now if @sticker.performer_id
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
    if @sticker.update(sticker_params)
      NoticeMailer.notice_of_appointment(@sticker).deliver_now if can_send_notifier?
      @sticker.destroy if @sticker.status == 'Закрыт'
      flash[:notice] = 'Стикер был успешно обновлен.'
      redirect_to stickers_path
    else
      render 'edit'
    end
  end

  def destroy
    if @sticker.is_destroyed?
      flash[:notice] = 'Стикер был успешно закрыт.'
      redirect_to stickers_path
    end
  end

  private

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