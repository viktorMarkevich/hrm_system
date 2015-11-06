# coding: utf-8
class Vacancy < ActiveRecord::Base
  acts_as_paranoid
  include RegionSupporter

  belongs_to :region
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :staff_relations
  has_many :candidates, through: :staff_relations, source: :candidate

  attr_accessor :sr_status

  validates :name, :region_id, :status, :user_id, presence: true
  validates :salary, numericality: { only_integer: true, greater_than: 0 }, unless: 'salary_format == "По договоренности"'

  after_restore :set_default_status
  after_destroy :set_closed_status

  STATUSES = %w(Не\ задействована В\ работе Закрыта)

  def candidates_with_status(status)
    Candidate.select(%{ "candidates".* })
             .joins(:staff_relations)
             .where(%{ "staff_relations"."vacancy_id" = #{self.id}
                    AND "staff_relations"."status" = '#{status}' })
  end

  def set_default_status
    self.update(status: 'Не задействована')
  end

  def set_closed_status
    self.update(status: 'Закрыта')
  end
end

