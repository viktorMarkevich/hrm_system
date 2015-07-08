# coding: utf-8

class StickersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_sticker, only: [:update, :edit, :destroy]

  def index
    @stickers = Sticker.page(params[:page]).per(8)
  end

  def new
    @sticker = Sticker.new
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
      flash[:notice] = 'Стикер был успешно обновлен.'
      redirect_to stickers_path
    else
      render 'edit'
    end
  end

  def destroy
    if @sticker.deleted_at.nil?
      if @sticker.destroy
        flash[:notice] = 'Стикер был успешно удален.'
        redirect_to stickers_path
      end
    else
      @sticker.restore
      flash[:notice] = 'Стикер был успешно восстановлен.'
      redirect_to restore_stickers_path
    end
  end

  def restore_sticker
    @stickers = Sticker.only_deleted
  end

  private
   def sticker_params
     params.require(:sticker).permit(:description, :performer_id, :status)
   end

   def find_sticker
     @sticker = Sticker.with_deleted.find(params[:id])
   end
end