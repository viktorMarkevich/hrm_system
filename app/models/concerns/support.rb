module Support

  extend ActiveSupport::Concern

  TRANSLATE_EXCEPTION = %w(original_cv_data company_id)

  def set_owner
    owner
  end

  def set_changes(attrs, additation_opts)
    changes = self.changes
    changes = remove_unnecessary_attributes(changes, attrs) if attrs
    if try(:will_begin_at)
      changes[:will_begin_at] = [nil, I18n.l(self.will_begin_at, format: '%d %B(%A) в %T')]
    end
    changes
  end

  def remove_unnecessary_attributes(changes, attrs)
    attrs.each{ |attr| changes.delete(attr) }
    changes
  end
end