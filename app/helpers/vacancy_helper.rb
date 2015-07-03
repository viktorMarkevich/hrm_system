module VacancyHelper

  def get_salary(vacancy)
    vacancy.salary_format != "По договоренности" ? "#{vacancy.salary}  #{vacancy.salary_format}" : "По договоренности"
  end

  def get_author_and_date(vacancy)
    "#{full_name_for(vacancy.owner)} #{vacancy.created_at.strftime('%F')}"
  end

end