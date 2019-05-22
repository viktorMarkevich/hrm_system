module VacanciesHelper

  def get_salary(vacancy)
    vacancy.salary_format != 'По договоренности' ? "#{vacancy.salary} #{vacancy.salary_format}" : 'По договоренности'
  end

  def get_label_class(status)
    case status
      when 'Не задействована'
        'label-default'
      when 'В работе'
        'label-success'
      when 'Закрыта'
        'label-danger'
    end
  end

  def get_active(current_status, status)
    if current_status
      current_status == status ? 'active' : ''
    else
      status == 'Найденные' ? 'active' : ''
    end
  end

end