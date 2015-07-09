class StaffRelation < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :candidate

  STATUSES = ['Найденные', 'Отобранные', 'Собеседование', 'Утвержден', 'Не подходит', 'Отказался']
end
