class AddColumnsToCandidates < ActiveRecord::Migration
  def up
    add_column :candidates, :email, :string
    add_column :candidates, :phone, :string
    add_column :candidates, :linkedin, :string
    add_column :candidates, :facebook, :string
    add_column :candidates, :vkontakte, :string
    add_column :candidates, :google_plus, :string
    add_column :candidates, :full_info, :text
  end
end
