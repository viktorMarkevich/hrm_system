require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  let(:user) { create :user}
  let(:vacancy) { create :vacancy, created_at: DateTime.new(2021, 05, 16) }

  context 'methods helper' do
    it 'method get_author_and_date' do
      expect(helper.get_author_and_date(vacancy)).to eq(get_author_and_date(vacancy))
    end
  end

  context 'returns message or field value for an user' do
    it 'returns users skype' do
      expect(helper.display_field_value_for(user.skype)).to eq(user.skype)
    end

    context 'when skype is nil' do
      it 'returns notification' do
        user = create(:user, skype: nil)
        expect(helper.display_field_value_for(user.skype)).to eq('Информация не добавлена')
      end
    end
  end

  context 'get_date_when_added method helper' do
    it 'return 2021-05-16' do
      expect(helper.get_date_when_added(vacancy)).to eq('2021-05-16')
    end
  end

  context 'get_author_vacancy method helper' do
    it 'return "user full_name"' do
      expect(helper.get_author_vacancy(vacancy)).to eq(user.full_name)
    end
  end

  context 'return_upcoming_events method helper' do
    let!(:vacancy) { create :vacancy, user_id: user.id }
    let!(:candidate) { create :candidate, user_id: user.id }
    let!(:staff_relation) { create :staff_relation, vacancy_id: vacancy.id, candidate_id: candidate.id }

    let!(:event) do  create :event, name: 'fdfdf', will_begin_at: (Time.zone.now.utc + 10.hours + 12.minutes).round.iso8601(0),
                            description: 'description', user_id: user.id, staff_relation_id: staff_relation.id
    end

    it 'return "upcoming events"' do
      expect(helper.return_upcoming_events(event)).to eq("&nbsp; c <a href=\"/candidates/#{event.staff_relation.candidate.id}\">Ланистер</a> на
     <div class= 'label label-info'>#{event.will_begin_at.strftime('%e %b %H:%M')}</div>
     на должность <a href=\"/vacancies/#{event.staff_relation.vacancy.id}\">Рубист</a>")
    end
  end

  context 'return_status_label method helper' do
    it 'return "default label"' do
      expect(helper.return_status_label('Найденные')).to eq('default')
    end

    it 'return "primary label"' do
      expect(helper.return_status_label('Отобранные')).to eq('primary')
    end

    it 'return "info label"' do
      expect(helper.return_status_label('Собеседование')).to eq('info')
    end

    it 'return "success label"' do
      expect(helper.return_status_label('Утвержден')).to eq('success')
    end

    it 'return "warning label"' do
      expect(helper.return_status_label('Не подходит')).to eq('warning')
    end

    it 'return "danger label"' do
      expect(helper.return_status_label('Отказался')).to eq('danger')
    end
  end

  context 'bootstrap_class_for method helper' do
    it 'return "default label"' do
      expect(helper.bootstrap_class_for('success')).to eq('alert-success')
    end

    it 'return "status label"' do
      expect(helper.bootstrap_class_for('error')).to eq('alert-error')
    end

    it 'return "status label"' do
      expect(helper.bootstrap_class_for('notice')).to eq('alert-info')
    end

    it 'return "status label"' do
      expect(helper.bootstrap_class_for('huy')).to eq('huy')
    end
  end

end