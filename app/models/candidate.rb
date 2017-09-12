# encoding: utf-8
class Candidate < ActiveRecord::Base

  acts_as_taggable

  acts_as_paranoid
  include Support

  acts_as_xlsx columns: [ :name, :desired_position, :city_of_residence, :salary, :'owner.full_name', :created_at,
                          :status, :notice ], i18n: true

  scope :with_status, -> (status) { where(status: "#{status}") }

  STATUSES = %w(Пассивен В\ работе)

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  belongs_to :company, counter_cache: true
  belongs_to :geo_name, counter_cache: true

  has_one :image

  has_many :staff_relations, dependent: :destroy
  has_many :vacancies, through: :staff_relations, source: :vacancy
  has_many :histories, as: :historyable

  accepts_nested_attributes_for :image

  validates :status, presence: true
  validates :name, :status, presence: true
  # validates :source, presence: true, if: 'file_name.nil?'
  # validates :source, uniqueness: true, if: 'source.present?'
  # validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/,
  #           message: 'is invalid.' }, if: 'email.present?'
  # validates :phone, format:  { with: /\+?\d{2}-\d{3}-\d{3}-\d{4}/,
  #          message: 'wrong format' }, if: 'phone.present?'
  # validates :email, uniqueness: true, if: 'email.present?'
  # validates :phone, uniqueness: true, if: 'phone.present?'
  # validates :skype, uniqueness: true,
  #                   length: { minimum: 6, maximum: 32 },
  #                   format: { with: /(\A[a-zA-Z]+\w*(?:[-.:]\w+)*\z)/, message: 'is invalid.' },
  #                   if: 'skype.present?'
  #validates :birthday, format: { with: /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/, multiline: true,
  #          message: 'wrong format' }, if: 'birthday.present?'

  before_validation :check_geo_name

  after_create -> { add_history_event_after_('create') }
  after_update -> { add_history_event_after_('update') }
  after_destroy  -> { add_history_after_paranoid_actions('destroy', 'В Архиве') }
  after_restore  -> { add_history_after_paranoid_actions('restore', 'Пассивен') }

  def status_for_vacancy(vacancy)
    StaffRelation.find_by_candidate_id_and_vacancy_id(self.id, vacancy.id).status
  end

  def is_passive?
    status == STATUSES[0]
  end

  def save_resume_to_candidate(data)
    content = Yomu.new(data).text.to_s
    tags = 'full-stack|front-end|back-end|ruby|rails|ror|php|python|javascript|html|css|js|mysql|postgresql|mongodb|linux|macos|mvc|git|ооп|oop|bootstrap|scrum|crm|1c|agile|java|yii|wordpress|svn|jquery|ajax|xml|json|less|sass|redis|memcached|sphinx|kohana|zend|codeigniter|photoshop|jade|emmet|word|excel|power point|singleton|factory|composer|highload|silex|cms|apache|nginx|twig|lamp|xamp|php-fpm|fpm|apc|redmine|sqlite|angular|react|heroku|test|rspec|restful|api|cucumber|ansible|sinatra|amazon|sql|lisp|prolog|visio|coreldraw|internet'
    lang = 'english|английский|англійська|russian|русский|російська|ukrainian|украинский|українська|français|french|французский|французька|deutsch|german|немецкий|німецька|polish|polski|польский|польська'
    self.name = content.scan(/(?:[A-Z]+[a-zA-Z]* [A-Z]+[a-zA-Z]*)|(?:[А-Я]+[а-яА-Я]* [А-Я]+[а-яА-Я]*)/).to_a.compact.first.to_s.strip
    self.birthday = content.scan(/\d{1,2}\-\d{1,2}\-\d{4}/).to_a.compact.first.to_s.strip ||
        content.scan(/\d{1,2}\/\d{1,2}\/\d{4}/).to_a.compact.first.to_s.strip ||
        content.scan(/\d{1,2}\.\d{1,2}\.\d{4}/).to_a.compact.first.to_s.strip
    self.salary = content.scan(/^*\s*(?=[-~])*[0-9]{2,7}\s*(?=грн|ГРН|usd|USD|долл|\$)/).to_a.compact.first.to_s.strip
    self.city_of_residence = content.scan(/(?<=Город:|Регион:|Адрес:)\s*$*.*(?=$)/).to_a.compact.first.to_s.strip
    self.file_name = data.original_filename
    self.tag_list = content.scan(/(?:#{tags})/i).to_a.compact.uniq.join(', ')
    self.languages = content.scan(/(?:#{lang})(?=[\.\-\/,:;\s$])/i).to_a.compact.uniq.join(', ')
    self.email = content.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).to_a.compact.first.to_s.strip
    self.phone = content.scan(/\b((?:[\s()\d-]{11,}\d)|\d{10,})\b/).to_a.compact.join(', ')
    self.skype = content.scan(/(?<=[Ss]kype:)\s*[a-zA-Z]+\w*(?:[-.:]\w+)*(?=[\s$])/).to_a.compact.first.to_s.strip
    self.linkedin = content.scan(/(?<=[Ll]inked[Ii]n:)\s*.*(?=[\s$])/).to_a.compact.first.to_s.strip
    self.facebook = content.scan(/(?<=[Ff]acebook:)\s*.*(?=[\s$])/).to_a.compact.first.to_s.strip
    self.vkontakte = content.scan(/(?<=[Vv]kontakte:|[Vv][Kk]:)\s*.*(?=[\s$])/).to_a.compact.first.to_s.strip
    self.google_plus = content.scan(/(?<=[Gg]oogle\+:|[Gg]oogle[Pp]lus:)\s*.*(?=[\s$])/).to_a.compact.first.to_s.strip
    self.original_cv_data = content
    self.save!
  end

  def self.to_csv
    column_names =  %w{ Кандидат Должность Регион Зарплата Ответственный Добавлен Статус Примечание }
    CSV.generate do |csv|
      csv << column_names
      all.each do |candidate|
        csv << [ candidate.name, candidate.desired_position, candidate.city_of_residence, candidate.salary,
                candidate.owner&.full_name, candidate.created_at.strftime('%F'), candidate.status, candidate.notice ]
      end
    end
  end

  private
  def check_geo_name
    self.geo_name_id = if city_of_residence.present?
                         GeoName.joins(:geo_alternate_names).find_by(fclass: 'P', geo_alternate_names: { name: self.city_of_residence })&.id
                       end || nil
  end

  def add_history_event_after_(action)
    attrs = %w(created_at updated_at user_id id)
    histories.create_with_attrs(was_changed: set_changes(attrs), action: action)
  end

  def add_history_after_paranoid_actions(action, new_status)
    old_status = self.status
    self.update_columns(status: new_status)
    histories.create_with_attrs(was_changed: { 'status' => "[\"#{old_status}\", \"#{new_status}\"]" }, action: action)
  end
end