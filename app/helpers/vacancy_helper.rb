module VacancyHelper

  def get_salary(vacancy)
    vacancy.salary_format != "По договоренности" ? "#{vacancy.salary}  #{vacancy.salary_format}" : "По договоренности"
  end

end