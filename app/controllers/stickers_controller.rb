# coding: utf-8

class StickersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_sticker, only: [:update, :edit, :destroy]

  def index
    @stickers = Sticker.all
  end

  def new
    @sticker = Sticker.new
  end

  def edit
  end

  def create
    @sticker = Sticker.new(sticker_params.merge(owner_id: current_user.id))
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
    if @sticker.destroy
      flash[:notice] = 'Стикер был успешно удален.'
      redirect_to stickers_path
    end
  end

  private
   def sticker_params
     params.require(:sticker).permit(:description, :performer_id)
   end

   def find_sticker
     @sticker = Sticker.find(params[:id])
   end
end