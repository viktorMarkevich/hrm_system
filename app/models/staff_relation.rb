class StaffRelation < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :candidate

  NEUTRAL = 'Нейтральный'
  FOUND = 'Найденные'
  SELECTED = 'Отобранные'
  INTERVIEW = 'Собеседование'
  APPROVED = 'Утвержден'
  NOT_SUITABLE = 'Не подходит'
  REFUSED = 'Отказался'
  STATUSES = [ NEUTRAL, FOUND, SELECTED, INTERVIEW, APPROVED, NOT_SUITABLE, REFUSED ]
end
