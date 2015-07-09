# coding: utf-8

class StickersController < ApplicationController
  load_and_authorize_resource param_method: :sticker_params

  before_filter :authenticate_user!
  before_filter :find_sticker, only: [:update, :edit, :destroy]
  before_filter :prepare_performers, only: [:new, :edit]

  def index
    @stickers = Sticker.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(8)
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
    if @sticker.destroy
      flash[:notice] = 'Стикер был успешно закрыт.'
      redirect_to stickers_path
    end
  end

  private
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