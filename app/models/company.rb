class Company < ActiveRecord::Base

  belongs_to :region

  validates :name, :region_id, presence: true
  validates :url,  format: { with: /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
                              message: 'address is invalid' }

end
