class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.string :name
      t.string :salary
      t.string :salary_format
      t.string :region
      t.string :languages
      t.string :status
      t.text :requirements

      t.timestamps null: false
    end
  end
end
