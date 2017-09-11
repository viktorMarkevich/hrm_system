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

  after_create -> { add_history_event_after_('create') }
  after_update -> { add_history_event_after_('update') }
  after_destroy  -> { add_history_after_paranoid_actions('destroy', 'В Архиве') }
  after_restore  -> { add_history_after_paranoid_actions('restore', 'Не задействована') }

  def candidates_with_status(status)
    Candidate.select(%{ "candidates".* }).joins(:staff_relations)
             .where(%{ "staff_relations"."vacancy_id" = #{self.id} AND "staff_relations"."status" = '#{status}' })
  end

  private

    def add_history_event_after_(action)
      attrs = '%w(created_at deleted_at user_id)'
      histories.create_with_attrs(was_changed: set_changes(attrs, nil), action: action)
    end

    def add_history_after_paranoid_actions(action, new_status)
      old_status = self.status
      self.update_columns(status: new_status)
      histories.create_with_attrs(was_changed: { 'status' => "[\"#{old_status}\", \"#{new_status}\"]" }, action: action)
    end
end

