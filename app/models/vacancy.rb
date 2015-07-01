class Vacancy < ActiveRecord::Base
  include RegionSupporter

  belongs_to :region
  belongs_to :user
  validates :name, :region_id, :status, :user_id, presence: true
  validates :salary, numericality: { only_integer: true }

  def creator
    UsersController.helpers.full_name_for(User.find(self.user_id))
  end

end