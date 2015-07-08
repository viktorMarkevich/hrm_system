class ArchivesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @stickers = Sticker.only_deleted.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(8)
  end

  def destroy
    @sticker = Sticker.only_deleted.find(params[:id])
    if @sticker.restore
      flash[:notice] = 'Стикер был успешно восстановлен.'
      redirect_to archives_stickers_path
    end
  end
end