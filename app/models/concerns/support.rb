module Support

  extend ActiveSupport::Concern

  TRANSLATE_EXCEPTION = %w(original_cv_data company_id)

  def set_owner
    owner
  end

  def set_changes(attrs, addition_attrs = nil)
    changes = self.changes
    changes = remove_unnecessary_attributes(changes, attrs) if attrs
    changes.merge!(addition_attrs) if addition_attrs
    changes
  end

  def remove_unnecessary_attributes(changes, attrs)
    attrs.each{ |attr| changes.delete(attr) }
    changes
  end
end