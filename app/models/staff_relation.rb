class StaffRelation < ActiveRecord::Base

  belongs_to :vacancy
  belongs_to :candidate
  has_many :events

  validates :vacancy_id,  uniqueness: { scope: :candidate_id }, presence: true
  STATUSES = %w(Убрать Найденные Отобранные Собеседование Утвержден Не\ подходит Отказался)

  # after_create :create_history_event
  # after_update :update_history_event

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
    StaffRelation.where('status IN (?)', ['Собеседование', 'Утвержден'])
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
        History.create_with_attrs(old_status: self.status_was,
                                  new_status: status,
                                  responsible: { full_name: vacancy.owner.full_name,
                                                 id: vacancy.user_id },
                                  action: "В вакансии <strong>#{vacancy.name}</strong> для кандидата <strong>#{candidate.name}</strong> произошли изменения")
      end
    end
end
