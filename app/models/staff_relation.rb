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

  def create_history_event
    History.create_with_attrs(old_status: 'Пасивен',
                              new_status: 'Найденные',
                              responsible: { full_name: vacancy.owner.full_name,
                                             id: vacancy.user_id },
                              action: "В вакансию <strong>#{vacancy.name}</strong> добавили нового кандидата <strong>#{candidate.name}</strong>")
  end

  def update_history_event
    unless self.status_was == status
      History.create_with_attrs(was_changed: set_changes, action: 'update', historyable_type: self.class.name, historyable_id: id)
    end
  end

  def add_history_event_after_(action)
    # unless self.status_was == status && action == 'create'
      histories.create_with_attrs(was_changed: set_changes, action: action)
    # end
  end

  def add_history_after_paranoid_actions(action, new_status)
    old_status = self.status
    # self.update_columns(status: new_status)
    histories.create_with_attrs(was_changed: { 'status' => "[\"#{old_status}\", \"#{new_status}\"]" }, action: action)
  end

  def set_changes
    changes = self.changes
    changes.delete('created_at')
    changes.delete('updated_at')
    changes.delete('id')
    changes
  end

end