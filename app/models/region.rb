class Region < ActiveRecord::Base

  has_many :users
  has_many :companies
  has_many :vacancies

  validates :name, presence: true, uniqueness: true

  REGIONS = %w(Запорожье Донецк Луганск Херсон Харьков Днепропетровск Николаев Одесса
               Кировоград Полтава Сумы Винница Черкассы Чернигов Киев Черновцы
               Тернополь Хмельницкий Житомир Ровно Луцк Львов Ивано-Франковск Ужгород АР\ Крым)

end
