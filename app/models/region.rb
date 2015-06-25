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

  def build_company(company_params)
    self.companies.build(company_params)
  end

  def build_vacancy(vacancy_params)
    self.vacancies.build(vacancy_params)
  end

  def build_user(user_params)
    self.users.build(user_params)
  end

end
