class StaffRelation < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :candidate
  belongs_to :event

  STATUSES = %w(Нейтральный Найденные Отобранные Собеседование Утвержден Не\ подходит Отказался)

  after_update :check_event

  def check_event
    if event_id_changed? && !event_id_was.nil?
      Event.find(event_id_was).destroy
    end
  end

  def change_candidate_status
    p '*'*1000
  end
end
