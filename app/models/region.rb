class Region < ActiveRecord::Base

  has_many :users
  has_many :companies
  has_many :vacancies

  validates :name, presence: true, uniqueness: true
  
end
