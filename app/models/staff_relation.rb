class StaffRelation < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :candidate
  belongs_to :event
  has_many :history_events, as: :history_eventable, dependent: :destroy

  STATUSES = %w(Нейтральный Найденные Отобранные Собеседование Утвержден Не\ подходит Отказался)

  after_create :set_found_status, unless: 'event_id.present?'

  def set_found_status
    self.update_attributes(status: 'Найденные')
    unless vacancy.status == Vacancy::STATUSES[1]
      vacancy.update_attributes(status: Vacancy::STATUSES[1])
    end
  end

  def self.return_status(options)
    staff_relation = where(candidate_id: options[:vacancy][:candidate_id], vacancy_id: options[:id]).first
    status = staff_relation.status
    if options[:vacancy][:sr_status] == 'Нейтральный'
      staff_relation.delete
    else
      staff_relation.update_attributes(status: options[:vacancy][:sr_status])
      staff_relation.history_events.create( old_status: status, new_status: options[:vacancy][:sr_status], user_id: options[:vacancy][:user_id] )
    end
    status
  end

  def self.get_without_event
    StaffRelation.where('status IN (?) and event_id IS NULL', ['Собеседование', 'Утвержден'])
  end
end
