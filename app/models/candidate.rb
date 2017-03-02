# encoding: utf-8
class Candidate < ActiveRecord::Base
  include ChangesHistory

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :image
  has_many :staff_relations, dependent: :destroy
  has_many :vacancies, through: :staff_relations, source: :vacancy
  belongs_to :company

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
                    format: { with: /(\A[a-zA-Z]+\w*(?:[-.:]\w+)*\z)/, message: 'is invalid.' },
                    if: 'skype.present?'
  #validates :birthday, format: { with: /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/, multiline: true,
  #          message: 'wrong format' }, if: 'birthday.present?'

  def status_for_vacancy(vacancy)
    StaffRelation.find_by_candidate_id_and_vacancy_id(self.id, vacancy.id).status
  end

  def is_passive?
    status == STATUSES[0]
  end

  def save_resume_to_candidate(data)
    content = Yomu.new(data).text.to_s
    self.name = content.scan(/(?:[A-Z]+[a-zA-Z]* [A-Z]+[a-zA-Z]*)|(?:[А-Я]+[а-яА-Я]* [А-Я]+[а-яА-Я]*)/).compact.first.strip
    self.birthday = content.scan(/\d{1,2}\-\d{1,2}\-\d{2,4}/).first.strip ||
        content.scan(/\d{1,2}\/\d{1,2}\/\d{2,4}/).first.strip ||
        content.scan(/\d{1,2}\.\d{1,2}\.\d{2,4}/).first.strip
    self.salary = content.scan(/^*\s*(?=[-~])*[0-9]{2,7}\s*(?=грн|ГРН|usd|USD|долл|\$)/).first.strip
    self.city_of_residence = content.scan(/(?<=Город:|Регион:|Адрес:)\s*$*.*(?=$)/).first.strip
    self.source = data.original_filename
    # self.education = content.scan(/(?<=[Оо]бразование[:\n]|[Ee]ducation[:\n])(.|\n)*\w+/).join('')
    self.languages = content.scan(/^*\s*(?:English|Английский|Англійська|Russian|Русский|Російська|Ukrainian|Украинский|Українська|Français|Polish)(?=[\.\-,:;\s$])/).compact.join(', ')
    self.email = content.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first.strip
    self.phone = content.scan(/\b((?:[\s()\d-]{11,}\d)|\d{10,})\b/).join(', ')
    self.skype = content.scan(/(?<=[Ss]kype:)\s*[a-zA-Z]+\w*(?:[-.:]\w+)*(?=[\s$])/).compact.first.strip
    self.linkedin = content.scan(/(?<=[Ll]inked[Ii]n:)\s*.*(?=[\s$])/).first.strip
    self.facebook = content.scan(/(?<=[Ff]acebook:)\s*.*(?=[\s$])/).first.strip
    self.vkontakte = content.scan(/(?<=[Vv]kontakte:|[Vv][Kk]:)\s*.*(?=[\s$])/).first.strip
    self.google_plus = content.scan(/(?<=[Gg]oogle\+:|[Gg]oogle[Pp]lus:)\s*.*(?=[\s$])/).first.strip
    self.description = content

    # self.experience = content.scan(/(?<=Опыт работы\n)((.|\n)*?)(?=Образование\n)/).join('')

    self.save!
  end
end
