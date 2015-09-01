# coding 'utf-8'
class AddDefaultValueForStatusToVacancies < ActiveRecord::Migration
  def change
    change_column :vacancies, :status, :string, default: 'Не задействована'
  end
end
