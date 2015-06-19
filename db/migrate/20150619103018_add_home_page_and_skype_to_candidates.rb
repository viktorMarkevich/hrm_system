class AddHomePageAndSkypeToCandidates < ActiveRecord::Migration
  def up
    add_column :candidates, :home_page, :string
    add_column :candidates, :skype, :string
  end

  def down
    remove_column :candidates, :home_page
    remove_column :candidates, :skype
  end
end
