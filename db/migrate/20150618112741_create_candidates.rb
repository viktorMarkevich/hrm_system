class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :birthday
      t.string :salary
      t.string :salary_format
      t.string :education
      t.string :languages
      t.string :city_of_residence
      t.string :ready_to_relocate
      t.string :desired_position
      t.string :experience
      t.string :status
      t.string :source
      t.string :description

      t.timestamps null: false
    end
  end
end
