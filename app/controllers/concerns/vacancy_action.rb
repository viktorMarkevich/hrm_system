module VacancyAction
  extend ActiveSupport::Concern

  included do
    before_filter :show_last_action_for_vacancy, only: [:index, :new, :edit, :show]
  end

  def show_last_action_for_vacancy
    @staffs = StaffRelation.where().order('status, updated_at DESC')
  end

end