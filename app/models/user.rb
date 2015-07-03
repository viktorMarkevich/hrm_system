class User < ActiveRecord::Base
  include RegionSupporter

  belongs_to :region
  has_many :vacancies
  has_many :owner_stickers, foreign_key: 'owner_id', class_name: 'Sticker'
  has_many :performer_stickers, foreign_key: 'performer_id', class_name: 'Sticker'

  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable

  has_attached_file :avatar, styles: { medium: '246x300>', thumb: '100x100>' }, default_url: 'default_:style.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
                                 message: 'is invalid.' }, if: 'skype.present?'

  validates :first_name, :last_name, :post, :region_id,  presence: true
  validates :skype, uniqueness: true, if: 'skype.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'
end