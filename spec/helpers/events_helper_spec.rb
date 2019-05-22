require 'rails_helper'

RSpec.describe EventsHelper, type: :helper do

  let(:user) { create :user }
  let(:vacancy) { create :vacancy, user_id: user.id }
  let(:candidate) { create :candidate, user_id: user.id }
  let!(:staff_relation) { create :staff_relation, vacancy_id: vacancy.id, candidate_id: candidate.id }

  # let(:history) { create :history, historyable_type: 'Vacancy', historyable_id: vacancy.id }
  #
  # let(:history_sr) { create :history, historyable_type: 'StaffRelation', historyable_id: staff_relation.id, was_changed: { "salary"=>"[\"550\", \"100\"]" } }
  let!(:event) do  create :event, name: 'fdfdf', will_begin_at: (Time.zone.now.utc + 10.hours + 12.minutes).round.iso8601(0),
                          description: 'description', user_id: user.id, staff_relation_id: staff_relation.id
  end

  context 'methods helper' do
    it 'method default_td_classes' do
      pending
      expect(helper.default_td_classes([event])).to eq([])
    end

    context 'method set_events_list_title' do
      it 'date is nil' do
        expect(helper.set_events_list_title([event])).to eq('Список предстоящих событий за Май')
      end

      it 'date is "Time.zone.now.utc + 10.hours"' do
        expect(helper.set_events_list_title([event], (Time.zone.now.utc))).to eq('Список предстоящих событий за Май')
      end

      it 'events are nil' do
        expect(helper.set_events_list_title([], (Time.zone.now.utc))).to eq('Список предстоящих событий за Май пуст')
      end

      it 'date and event are nil' do
        expect(helper.set_events_list_title([])).to eq('Список предстоящих событий пуст')
      end
    end

    it 'date and event are nil' do
      expect(helper.get_sr_name(staff_relation)).to eq("#{vacancy.name + ' | Кандидат: ' +
                                              candidate.name + ' | ' +
                                              staff_relation.status}")
    end
  end
end
