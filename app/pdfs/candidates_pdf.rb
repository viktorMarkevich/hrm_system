class CandidatesPdf < Prawn::Document
  def initialize(candidates)
    super()
    @candidates = candidates
    font_families.update("OpenSans" => {
        # normal: '/assets/fonts/OpenSans-Regular.ttf',
        # italic: '/assets/fonts/OpenSans-Italic.ttf',
        normal: Rails.root.join('app','assets','fonts','OpenSans-Regular.ttf')
    })
    puts font_families
    font "OpenSans", size: 10 do
      data = [%w{Кандидат Должность Регион Зарплата Ответственный Добавлен Статус Примечание}]
      candidates.each do |candidate|
        data += [[candidate.name, candidate.desired_position, candidate.city_of_residence, candidate.salary, candidate.owner&.full_name,
                 candidate.created_at.strftime('%F'), candidate.status, candidate.notice]]
      end
      table(data, :header => true)
    end
  end
end