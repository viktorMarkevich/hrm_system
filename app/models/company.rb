class Company < ActiveRecord::Base
  validates :name, presence: true
  validates :url,  format: URI::regexp(%w(http https))
end
