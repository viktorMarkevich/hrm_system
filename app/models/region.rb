class Region < ActiveRecord::Base

  has_many :users
  has_many :companies
  has_many :vacancies

  validates :name, presence: true, uniqueness: true

  NAMES = [
      'Запорожье', 'Донецк', 'Луганск', 'Херсон', 'Харьков',
      'Днепропетровск', 'Николаев', 'Одесса', 'Кировоград', 'Полтава',
      'Сумы', 'Винница', 'Черкассы', 'Чернигов', 'Киев',
      'Черновцы', 'Тернополь', 'Хмельницкий', 'Житомир', 'Ровно',
      'Луцк', 'Львов', 'Ивано-Франковск', 'Ужгород', 'АР Крым'
  ]

  def self.find_or_create(region_name)
    where(name: region_name).first_or_create
  end

  def assign_company(company_params)
    self.companies.first_or_initialize(company_params)
  end

  def assign_vacancy(vacancy_params)
    self.vacancies.first_or_initialize(vacancy_params)
  end

  def assign_user(user_params)
    self.users.first_or_initialize(user_params)
  end

end
