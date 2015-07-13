namespace :candidates do
  #TODO check this after all task are completed
  desc 'Sets default status "Нейтральный" to all candidates'
  task set_default_status: :environment do
    StaffRelation.delete_all
    default_status = 'Нейтральный'
    Candidate.all.each do |candidate|
      print '+ '
      StaffRelation.create(candidate_id: candidate.id, status: default_status)
    end
    puts
  end

  desc 'Set status "Пассивен" as default to all candidates'
  task set_passive_status: :environment do
    Candidate.all.each do |candidate|
      candidate.update(status: 'Пассивен')
    end
  end

end
