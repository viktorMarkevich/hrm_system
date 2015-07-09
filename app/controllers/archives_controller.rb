class ArchivesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @objects = klass.includes(:owner, :performer).order('created_at desc').page(params[:page]).per(8)
  end

  def destroy
    @sticker = klass.find(params[:id])
    if @sticker.restore
      flash[:notice] = 'Стикер был успешно восстановлен.'
      redirect_to archives_stickers_path
    end
  end

  private

    def klass
      @partial_name = params[:object_name]
      @partial_name.singularize.classify.constantize.only_deleted
    end
end