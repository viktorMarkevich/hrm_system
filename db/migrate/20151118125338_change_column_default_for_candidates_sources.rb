# coding 'utf-8'
class ChangeColumnDefaultForCandidatesSources < ActiveRecord::Migration
  def change
    change_column_default :candidates, :source, 'Другой источник'
  end
end
