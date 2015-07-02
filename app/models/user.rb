class User < ActiveRecord::Base
  include RegionSupporter

  belongs_to :region
  has_one :image

  after_create :assign_image

  accepts_nested_attributes_for :image

  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable

  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
                                 message: 'is invalid.' }, if: 'skype.present?'

  validates :first_name, :last_name, :post, :region_id,  presence: true
  validates :skype, uniqueness: true, if: 'skype.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'

  private
    def assign_image
      self.create_image
    end
end
