class Company < ActiveRecord::Base
  include RegionSupporter

  belongs_to :region
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :candidates

  validates :name, :region_id, presence: true
  validates :url,  format: { with: /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
                              message: 'address is invalid' }

  def self.get_company_name
    ['Не работал'] + self.all.map{ |p| [p.name, p.id] }
  end

end