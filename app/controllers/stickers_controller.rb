# coding: utf-8

class StickersController < ApplicationController
  def index
    @stickers = Sticker.all
  end

  def show
    @sticker = Sticker.find(params[:id])
  end

  def new
    @sticker = Sticker.new
  end

  def create
    @sticker = Sticker.new(sticker_params)
    if @sticker.save
      flash[:notice] = 'Стикер был успешно создан.'
      redirect_to stickers_path
    else
      render 'new'
    end
  end

  def edit
    @sticker = Sticker.find(params[:id])
  end

  def update
    @sticker = Sticker.find(params[:id])
    if @sticker.update(sticker_params)
      flash[:notice] = 'Стикер был успешно обновлен.'
      redirect_to stickers_path
    else
      render 'edit'
    end
  end

  def destroy
    @sticker = Sticker.find(params[:id])
    if @sticker.destroy
      flash[:notice] = 'Стикер был успешно удален.'
      redirect_to stickers_path
    end
  end

  private
   def sticker_params
     params.require(:sticker).permit(:title, :description)
   end
end
