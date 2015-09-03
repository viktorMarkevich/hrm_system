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

  def self.update_status(options)
    sr = where(candidate_id: options[:vacancy][:candidate_id], vacancy_id: options[:id]).first
    sr.update_attributes(status: options[:vacancy][:sr_status])
  end
end
