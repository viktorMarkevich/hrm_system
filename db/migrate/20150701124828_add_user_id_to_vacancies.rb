class AddUserIdToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :user_id, :integer
  end
end
