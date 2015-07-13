module CandidatesHelper

  def desired_salary_for(candidate)
    "#{candidate.salary} #{candidate.salary_format}"
  end

end
