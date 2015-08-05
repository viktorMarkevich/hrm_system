class StaffRelation < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :candidate

  STATUSES = %w(Нейтральный Найденные Отобранные Собеседование Утвержден Не\ подходит Отказался)

end
