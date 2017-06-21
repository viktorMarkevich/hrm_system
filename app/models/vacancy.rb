# coding: utf-8
class Vacancy < ActiveRecord::Base

  acts_as_paranoid
  include Support

  STATUSES = %w(Не\ задействована В\ работе Закрыта)

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  has_many :staff_relations
  has_many :candidates, through: :staff_relations, source: :candidate
  has_many :histories, as: :historyable

  attr_accessor :sr_status

  validates :name, :region, :status, :user_id, presence: true
  validates :salary, numericality: { only_integer: true, greater_than: 0 }, unless: 'salary_format == "По договоренности"'

  after_restore :set_default_status
  after_destroy :set_closed_status
  after_create :add_history_event_after_create
  after_update :add_history_event_after_update
  # after_destroy :add_history_event_after_destroy
  # after_restore :add_history_event_after_restore

  def candidates_with_status(status)
    Candidate.select(%{ "candidates".* }).joins(:staff_relations)
             .where(%{ "staff_relations"."vacancy_id" = #{self.id}
                    AND "staff_relations"."status" = '#{status}' })
  end

  def set_default_status
    self.update(status: 'Не задействована')
  end

  def set_closed_status
    self.update(status: 'Закрыта')
  end

  private
  def add_history_event_after_create
    histories.create_with_attrs(was_changed: set_changes, action: 'create')
  end

  def add_history_event_after_update
    History.create_with_attrs(was_changed: set_changes, action: 'update', historyable_type: 'Vacancy', historyable_id: id)
  end

  # def add_history_event_after_destroy   # TODO  old status
  #   History.create_with_attrs(new_status: 'В архиве',
  #                           responsible: {
  #                               full_name: owner.full_name,
  #                               id: user_id },
  #                           action: "Вакансия <strong>#{name}</strong> перемещена в архив")
  # end
  #
  # def add_history_event_after_restore # TODO  old status
  #   History.create_with_attrs(new_status: 'Восстановлена',
  #                             responsible: {
  #                                 full_name: owner.full_name,
  #                                 id: user_id },
  #                             action: "Вакансия <strong>#{name}</strong> восстановлена из архива")
  # end

end

