class User < ActiveRecord::Base

  POST = %w(Директор HR\ Менеджер)

  cattr_accessor :current_user

  has_one :image

  has_many :vacancies
  has_many :candidates
  has_many :companies
  has_many :events
  has_many :stickers, foreign_key: 'user_id', class_name: 'Sticker', dependent: :destroy

  accepts_nested_attributes_for :image

  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/, message: 'is invalid.' }, if: 'skype.present?'
  validates :first_name, :last_name, :post, :region,  presence: true
  validates :skype, uniqueness: true, if: 'skype.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'

  after_create :assign_image

  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :registerable

  def is_director?
    self.post == 'Директор'
  end

  def self.get_performers
    where(post: 'HR Менеджер').map { |p| [ p.full_name, p.id ] }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private
  def assign_image
    self.create_image
  end

end