module Support

  extend ActiveSupport::Concern

  TRANSLATE_EXCEPTION = %w(original_cv_data company_id)

  def set_owner
    owner
  end

  def set_changes
    changes = self.changes
    changes.delete('created_at')
    changes.delete('updated_at')
    changes.delete('user_id') if try(:user_id)
    if try(:will_begin_at)
      changes[:will_begin_at] = [nil, I18n.l(self.will_begin_at, format: '%d %B(%A) в %T')]
    end
    changes.delete('id')
    changes
  end

end