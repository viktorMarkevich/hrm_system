# encoding: utf-8
class Candidate < ActiveRecord::Base
  include ChangesHistory

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :image
  has_many :staff_relations, dependent: :destroy
  has_many :vacancies, through: :staff_relations, source: :vacancy
  belongs_to :company
  belongs_to :geo_name

  accepts_nested_attributes_for :image

  after_commit :write_history, on: :update

  scope :with_status, -> (status) { where(status: "#{status}") }

  STATUSES = %w(Пассивен В\ работе)
  # STATUSES = %w(В\ активном\ поиске В\ пассивном\ поиске В\ резерве)

  validates :name, :status, :source, presence: true
  # validates :source, uniqueness: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/,
            message: 'is invalid.' }, if: 'email.present?'
  #validates :phone, format:  { with: /\+?\d{2}-\d{3}-\d{3}-\d{4}/,
  #          message: 'wrong format' }, if: 'phone.present?'
  validates :email, uniqueness: true, if: 'email.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'
  validates :skype, uniqueness: true,
                    length: { minimum: 6, maximum: 32 },
                    format: { with: /(\A[a-zA-Z]+\w*([-.:]\w+)*\z)/, message: 'is invalid.' },
                    if: 'skype.present?'
  #validates :birthday, format: { with: /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/, multiline: true,
  #          message: 'wrong format' }, if: 'birthday.present?'
  before_validation :check_geo_name, on: [ :create, :update ]

  def status_for_vacancy(vacancy)
    StaffRelation.find_by_candidate_id_and_vacancy_id(self.id, vacancy.id).status
  end

  def is_passive?
    status == STATUSES[0]
  end

  def save_resume_to_candidate(data)
    file = Yomu.new(data)
    file_source = data.original_filename.scan(/(?:[\s]*|^)(rabota.ua|Workua)(?=[\s]*|$)/).first[0]
    content = file.text.to_s
    full_name = content.scan(/([A-Z]+[a-zA-Z]* [A-Z]+[a-zA-Z]*)|([А-Я]+[а-яА-Я]* [А-Я]+[а-яА-Я]*)/).first.compact.first
    self.name = full_name
    if file_source == "rabota.ua" then
      # self.education = content.scan(/(?<=Образование\n)((.|\n)*?)(?=Профессиональные навыки)/).join('')
      # self.experience = content.scan(/(?<=Опыт работы\n)((.|\n)*?)(?=Образование\n)/).join('')
      # self.city_of_residence = content.scan(/(?:[\s]*|^)(Kiev||Українська|Français|Ukrainian|Russian|Polish)(?=[\s]*|$)/).first.join('')
      # # self.ready_to_relocate
      # self.desired_position = content.scan(/([A-Z]+[a-zA-Z._%+-]*)/).first.join('')
    elsif file_source == "Workua" then
      self.education = content.scan(/(?<=Образование\n)((.|\n)*?)(?=Профессиональные навыки)/).join('')
      self.experience = content.scan(/(?<=Опыт работы\n)((.|\n)*?)(?=Образование\n)/).join('')
      self.city_of_residence = content.scan(/(?<=Город: )([^\n\r]*)/).first.join('')
      # # self.ready_to_relocate
      self.desired_position = content.scan(/([A-Z]+[a-zA-Z._%+-]*)/).first.join('')
    end
    self.birthday = content.scan(/\d{1,2}\-\d{1,2}\-\d{4}/).first ||
        content.scan(/\d{1,2}\/\d{1,2}\/\d{4}/).first ||
        content.scan(/\d{1,2}\.\d{1,2}\.\d{4}/).first
    self.languages = content.scan(/(?:[\s]|^)(English|Русский|Українська|Français|Ukrainian|Russian|Polish)(?=[\s]|$)/).compact.join(', ')
    self.source = data.original_filename
    self.email = content.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
    self.phone = content.scan(/\b((?:[\s()\d-]{11,}\d)|\d{10,})\b/).join(', ')
    self.skype = content.scan(/(?<=kype: )([^\n\r]*)/).compact.join()
    self.linkedin = content.scan(/[^\s]*linkedin[^\s]*/).first
    self.facebook = content.scan(/[^\s]*facebook[^\s]*/).first
    self.vkontakte = content.scan(/[^\s]*vk.com[^\s]*/).first
    self.google_plus = content.scan(/[^\s]*plus.google.com[^\s]*/).first
    self.description = content

    self.save!
  end

  private
    def check_geo_name
      if self.city_of_residence.blank?
        self.geo_name = nil
      else
        self.geo_name = GeoName.joins(:geo_alternate_names).find_by(fclass: 'P', geo_alternate_names: {name: self.city_of_residence})
      end
    end
end
