module ApplicationHelper

  def display_field_value_for(field)
    field.nil? || field.empty? ? 'Информация не добавлена' : field
  end

  def get_author_and_date(object)
    "#{full_name_for(object.owner)} #{object.created_at.strftime('%F')}"
  end

  def return_upcoming_events(event)
    "&nbsp; c #{link_to Candidate.first.name, candidate_path(Candidate.first)} на #{event.starts_at.strftime('%e %b %H:%M')}
     на должность #{link_to Vacancy.last.name, vacancy_path(Vacancy.last)}".html_safe
  end

end