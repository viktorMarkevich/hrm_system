module VacancyHelper

  def get_salary(vacancy)
    vacancy.salary_format != "По договоренности" ? "#{vacancy.salary} #{vacancy.salary_format}" : "По договоренности"
  end

  # def select_vacancy_status
  #   vacancies = Vacancy::STATUSES
  #   options = []
  #   vacancies.each do |vs|
  #     options << [
  #         {
  #             'Не задействована' =>  {class: 'label label-info'},
  #             vs[2] =>  {class: 'label label-danger'}
  #         }
  #     ]
  #   end
  #   options
  # end

end