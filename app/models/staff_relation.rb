class StaffRelation < ActiveRecord::Base
  include ChangesHistory

  belongs_to :vacancy
  belongs_to :candidate
  belongs_to :event
  has_many :history_events, as: :history_eventable, dependent: :destroy


  STATUSES = %w(Нейтральный Найденные Отобранные Собеседование Утвержден Не\ подходит Отказался)

  after_create :set_found_status, unless: 'event_id.present?'
  # after_commit :write_history, on: :update

  # after_update :check_event
  #
  # def check_event
  #   if event_id_changed? && !event_id_was.nil?
  #     Event.find(event_id_was).destroy
  #   end
  # end

  def set_found_status

    self.update_attributes(status: 'Найденные')

    unless vacancy.status == Vacancy::STATUSES[1]
      vacancy.update_attributes(status: Vacancy::STATUSES[1])
    end
  end

  def self.return_status(options)
    p '*'*100
    p options


    staff_relation = where(candidate_id: options[:vacancy][:candidate_id], vacancy_id: options[:id]).first
    status = staff_relation.status
    p staff_relation
    if options[:vacancy][:sr_status] == 'Нейтральный'
      staff_relation.delete
    else
      staff_relation.update_attributes(status: options[:vacancy][:sr_status])
      history_event = staff_relation.history_events.create( old_status: status, new_status: options[:vacancy][:sr_status], user_id: options[:vacancy][:user_id] )
    end
    status
  end

  def self.get_without_event
    StaffRelation.where('status IN (?) and event_id IS NULL', ['Собеседование', 'Утвержден'])
  end

end
