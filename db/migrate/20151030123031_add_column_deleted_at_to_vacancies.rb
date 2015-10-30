class AddColumnDeletedAtToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :deleted_at, :time
  end
end
