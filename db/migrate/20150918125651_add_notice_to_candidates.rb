class AddNoticeToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :notice, :string
  end
end
