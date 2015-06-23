class User < ActiveRecord::Base

  belongs_to :region

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: '290x300>', thumb: '100x100>' }, default_url: 'cat_2.jpg'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
                                 message: 'is invalid.' }, if: 'skype.present?'

  validates :first_name, :last_name, :post, presence: true
  validates :skype, uniqueness: true, if: 'skype.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'
  validates :region_id, presence: true
end
