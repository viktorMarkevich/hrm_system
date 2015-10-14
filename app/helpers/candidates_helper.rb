module CandidatesHelper

  def desired_salary_for(candidate)
    "#{candidate.salary} #{candidate.salary_format}"
  end

  def set_the_percentage_of_completed_fields(candidate)
    attr = candidate.attributes
    attr_numbs = attr.length
    current_attr_numbs = attr.values.compact.delete_if{ |d| d == '' }.length
    ((100.0*current_attr_numbs)/attr_numbs).round(1)
  end

  def get_sr_label_class(vacancy, candidate)
    case sr_status(vacancy, candidate)
      when 'Найденные'
        'btn-default'
      when 'Отобранные'
        'btn-primary'
      when 'Собеседование'
        'btn-info'
      when 'Утвержден'
        'btn-success'
      when 'Не подходит'
        'btn-warning'
      when 'Отказался'
        'btn-danger'
      else
        []
    end
  end

  def sr_status(vacancy, candidate)
    vacancy.staff_relations.select{|s| s.candidate_id == candidate.id }.first.status
  end

end
