module VacancyHelper

  def get_salary(vacancy)
    vacancy.salary_format != "По договоренности" ? "#{vacancy.salary} #{vacancy.salary_format}" : "По договоренности"
  end

  def get_label_class(vacancy)
    case vacancy.status
      when 'Не задействована'
        'label-default'
      when 'В работе'
        'label-success'
      when 'Закрыта'
        'label-danger'
    end
  end

end