class ArchivesController < ApplicationController

  before_action :authenticate_user!

  def index
    @objects = klass.all.order('created_at desc').page(params[:page]).per(10)
  end

  def destroy
    @object = klass.with_deleted.find(params[:id])
    if @object.restore
      flash[:notice] = 'Объект был успешно восстановлен.'
      redirect_to archives_path(object_name: @object.class.to_s.downcase.pluralize)
    end
  end

  private

    def klass
      @partial_name = params[:object_name]
      @partial_name.singularize.classify.constantize.only_deleted
    end

end