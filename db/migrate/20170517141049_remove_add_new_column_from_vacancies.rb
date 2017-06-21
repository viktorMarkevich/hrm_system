class RemoveAddNewColumnFromVacancies < ActiveRecord::Migration[5.0]
  def up
    remove_column :vacancies, :region_id
    add_column :vacancies, :region, :string
  end

  def down
    remove_column :vacancies, :region
    add_column :vacancies, :region_id
  end
end
