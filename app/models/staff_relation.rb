class StaffRelation < ActiveRecord::Base

  include Support

  STATUSES = %w(Убрать Найденные Отобранные Собеседование Утвержден Не\ подходит Отказался)

  belongs_to :vacancy
  belongs_to :candidate

  has_many :events
  has_many :histories, as: :historyable

  validates :vacancy_id,  uniqueness: { scope: :candidate_id }, presence: true

  after_create -> { add_history_event_after_('create') }
  after_update -> { add_history_event_after_('update') }
  after_destroy -> { add_history_after_paranoid_actions('destroy', 'Убрать') }

  def set_owner
    vacancy.owner
  end

  def self.return_status(options)
    staff_relation = where(candidate_id: options[:vacancy][:candidate_id], vacancy_id: options[:id]).first
    status = staff_relation.status
    if options[:vacancy][:sr_status] == 'Убрать'
      staff_relation.delete
    else
      staff_relation.update_attributes(status: options[:vacancy][:sr_status])
      staff_relation.histories.create( old_status: status, new_status: options[:vacancy][:sr_status], user_id: options[:vacancy][:user_id] )
    end
    status
  end

  def self.get_without_event
    StaffRelation.where('status IN (?)', [ 'Собеседование', 'Утвержден' ])
  end

  private

    def add_history_event_after_(action)
      attrs = %w(created_at updated_at id)
      histories.create_with_attrs(was_changed: attrs, action: action)
    end

    def add_history_after_paranoid_actions(action, new_status)
      old_status = self.status
      histories.create_with_attrs(was_changed: { 'status' => "[\"#{old_status}\", \"#{new_status}\"]" }, action: action)
    end
end