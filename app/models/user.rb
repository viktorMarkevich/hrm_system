class User < ActiveRecord::Base

  include RegionSupporter
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :registerable

  belongs_to :region
  has_one :image
  has_many :vacancies
  has_many :owner_stickers, foreign_key: 'owner_id', class_name: 'Sticker', dependent: :destroy
  has_many :candidates
  has_many :companies
  has_many :events

  accepts_nested_attributes_for :image

  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
                              message: 'is invalid.' }, if: 'skype.present?'
  validates :first_name, :last_name, :post, :region_id,  presence: true
  validates :skype, uniqueness: true, if: 'skype.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'

  after_create :assign_image

  POST = %w(Директор HR\ Менеджер)

  def is_director?
    self.post == 'Директор'
  end

  def self.get_performers
    where(post: 'HR Менеджер').map { |p| [p.full_name, p.id] }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private
    def assign_image
      self.create_image
    end
end