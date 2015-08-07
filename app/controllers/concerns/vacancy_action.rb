module VacancyAction
  extend ActiveSupport::Concern

  included do
    before_filter :show_last_action_for_vacancy, only: [:index, :new, :edit, :show]
  end

  def show_last_action_for_vacancy
    @staff_relations = StaffRelation.order('updated_at DESC').limit(5)
  end

end