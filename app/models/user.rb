class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
                                 message: 'Wrong format skype' }, if: 'skype.present?'

  validates :first_name, :last_name, :post, presence: true
  validates :skype, uniqueness: true, if: 'skype.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'
end
