# coding: utf-8

class StickersController < ApplicationController
  load_and_authorize_resource param_method: :sticker_params

  before_filter :authenticate_user!
  before_filter :find_sticker, only: [:update, :edit, :destroy]

  def new
    @sticker = Sticker.new
  end

  def edit
  end

  def create
    @sticker = current_user.owner_stickers.build(sticker_params.merge(bg_color: Sticker::BG_COLOR.sample))
    respond_to do |format|
      if @sticker.save
        set_stickers
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
        flash[:notice] = 'Стикер был успешно обновлен.'
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @sticker.errors.full_messages,
                             status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @sticker.destroy
      set_stickers
      flash[:notice] = 'Стикер был успешно закрыт.'
      respond_to do |format|
        format.js
        format.html { redirect_to organisers_url }
        format.json { head :no_content }
      end
    end
  end

  private

    def set_stickers
      @stickers = current_user.owner_stickers.order('created_at desc').page(params[:page]).per(11)
    end

    def sticker_params
      params.require(:sticker).permit(:description)
    end

    def find_sticker
      @sticker = Sticker.find(params[:id])
    end
end