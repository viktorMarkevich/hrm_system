class Candidate < ActiveRecord::Base
  has_one :image

  validates :name, :desired_position, :status, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/,
                              message: 'is invalid.' }, if: 'email.present?'
  # validates :phone, format: { with: /\A\+?[3]\d{11}\z/, message: 'is invalid.' }, if: 'phone.present?'
  validates :phone, format:  { with: /\+?\d{2}-\d{3}-\d{3}-\d{4}/, message: 'wrong format' }, if: 'phone.present?'
  validates :skype, format: { with: /\A[a-zA-Z][a-zA-Z0-9\.,\-_]{5,31}\z/,
                              message: 'is invalid.' }, if: 'skype.present?'
  validates :email, uniqueness: true, if: 'email.present?'
  validates :phone, uniqueness: true, if: 'phone.present?'
  validates :skype, uniqueness: true, if: 'skype.present?'

end
