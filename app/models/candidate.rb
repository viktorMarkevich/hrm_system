class Candidate < ActiveRecord::Base

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :image
  has_many :staff_relations, dependent: :destroy
  has_many :vacancies, through: :staff_relations, source: :vacancy
  belongs_to :company

  accepts_nested_attributes_for :image

  scope :with_status, -> (status) { where(status: "#{status}") }

  STATUSES = %w(Пассивен В\ работе)
  # STATUSES = %w(В\ активном\ поиске В\ пассивном\ поиске В\ резерве)

  validates :name, :status, :source, presence: true
  validates :source, uniqueness: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/,
            message: 'is invalid.' }, if: 'email.present?'
  #validates :phone, format:  { with: /\+?\d{2}-\d{3}-\d{3}-\d{4}/,
  #          message: 'wrong format' }, if: 'phone.present?'
  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
            message: 'is invalid.' }, if: 'skype.present?'
  validates :email, uniqueness: true, if: 'email.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'
  validates :skype, uniqueness: true, if: 'skype.present?'
  #validates :birthday, format: { with: /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/, multiline: true,
  #          message: 'wrong format' }, if: 'birthday.present?'

  def status_for_vacancy(vacancy)
    StaffRelation.find_by_candidate_id_and_vacancy_id(self.id, vacancy.id).status
  end

  def is_passive?
    status == STATUSES[0]
  end

  def save_resume_to_candidate(data)
    file = Yomu.new(data)
    content = file.text
    full_name = content.scan(/([A-Z]+[a-zA-Z]* [A-Z]+[a-zA-Z]*)|([А-Я]+[а-яА-Я]* [А-Я]+[а-яА-Я]*)/).first.compact.first
    self.name = full_name || 'fake_name'
    self.phone = content.scan(/\b((?:[\s()\d-]{11,}\d)|\d{10,})\b/).join(', ')
    self.email = content.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
    self.birthday = content.scan(/\d{1,2}\-\d{1,2}\-\d{4}/).first ||
                         content.scan(/\d{1,2}\/\d{1,2}\/\d{4}/).first ||
                         content.scan(/\d{1,2}\.\d{1,2}\.\d{4}/).first
    self.facebook = content.scan(/[^\s]*facebook[^\s]*/).first
    self.vkontakte = content.scan(/[^\s]*vk.com[^\s]*/).first
    self.google_plus = content.scan(/[^\s]*plus.google.com[^\s]*/).first
    self.description = content
    self.source = data.original_filename
    self.save!
  end
end
