class Candidate < ActiveRecord::Base

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_one :image
  has_many :staff_relations
  has_many :vacancies, through: :staff_relations, source: :vacancy

  accepts_nested_attributes_for :image
  #TODO might be unneccessary
  scope :with_status, -> (status) { Candidate.select(%{ "candidates".* })
                                            .joins(:staff_relations)
                                            .where(%{ "staff_relations"."status" = '#{status}' }) }

  POST = ['должность1', 'должность2', 'должность3']
  STATUS = ['Пассивен', 'В работе']

  validates :name, :desired_position, :status, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/,
            message: 'is invalid.' }, if: 'email.present?'
  validates :phone, format:  { with: /\+?\d{2}-\d{3}-\d{3}-\d{4}/,
            message: 'wrong format' }, if: 'phone.present?'
  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
            message: 'is invalid.' }, if: 'skype.present?'
  validates :linkedin, format: { with: /(http|https):\/\/?((www|\w\w)\.)?linkedin.com(\w+:{0,1}\w*@)?(\S+)(:([0-9])+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/,
            message: 'wrong format' }, if: 'linkedin.present?'
  validates :facebook, format: { with: /(https)?:\/\/www\.facebook\.com\/\w+\.\w+/,
            message: 'wrong format' }, if: 'facebook.present?'
  validates :vkontakte, format: { with: /http:\/\/vk.com\/(id\w+|\w+)/,
            message: 'wrong format' }, if: 'vkontakte.present?'
  validates :google_plus, format: { with: /https:\/\/plus\.google\.com\/.?\/?.?\/?([0-9]*)/,
            message: 'wrong format' }, if: 'google_plus.present?'
  validates :home_page, format: { with: /(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?/,
            message: 'wrong format' }, if: 'home_page.present?'
  validates :email, uniqueness: true, if: 'email.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'
  validates :skype, uniqueness: true, if: 'skype.present?'
  validates :birthday, format: { with: /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/, multiline: true,
            message: 'wrong format' }, if: 'birthday.present?'

  def desired_salary
    "#{salary} #{salary_format}"
  end

  def get_status_for_vacancy(vacancy)
    StaffRelation.where(candidate_id: self.id, vacancy_id: vacancy.id).first.status
  end
end
