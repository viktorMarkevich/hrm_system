namespace :candidates do
  desc 'Sets default status "Нейтральный" to all candidates'
  task set_default_status: :environment do
    default_status = 'Нейтральный'
    Candidate.all.each do |candidate|
      print '+ '
      StaffRelation.create(candidate_id: candidate.id, status: default_status)
    end
  end
end
