class Vacancy < ActiveRecord::Base
  include RegionSupporter

  belongs_to :region
  belongs_to :user

  validates :name, :region_id, :status, :user_id, presence: true
  validates :salary, numericality: { only_integer: true, greater_than: 0 }

  def creator
    UsersController.helpers.full_name_for(User.find(self.user_id))
  end

  def get_salary
    salary_format != "По договоренности" ? "#{salary}  #{salary_format}" : "По договоренности"
  end

end