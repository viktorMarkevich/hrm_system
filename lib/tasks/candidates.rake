namespace :candidates do
  #TODO check this after all task are completed
  desc 'Sets default status "Найденные" to all candidates'
  task set_default_status: :environment do
    StaffRelation.delete_all
    default_status = 'Найденные'
    Candidate.all.each do |candidate|
      print '+ '
      StaffRelation.create(candidate_id: candidate.id, status: default_status)
    end
    puts
  end
end

namespace :history do
  desc 'remove histories'
  task delete_all: :environment do
    History.delete_all
  end
end