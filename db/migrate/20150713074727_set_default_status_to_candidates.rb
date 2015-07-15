class SetDefaultStatusToCandidates < ActiveRecord::Migration
  def change
    change_column :candidates, :status, :string, default: 'Пассивен'
  end
end
