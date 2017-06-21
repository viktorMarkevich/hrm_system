class AddFileNameToCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :file_name, :string
  end
end
