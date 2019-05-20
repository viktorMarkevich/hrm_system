require 'rails_helper'

RSpec.describe OrganizersHelper, type: :helper do

  let(:user) { create :user }
  let(:vacancy) { create :vacancy, user_id: user.id }
  let(:candidate) { create :candidate, user_id: user.id }
  let!(:staff_relation) { create :staff_relation, vacancy_id: vacancy.id, candidate_id: candidate.id }

  let(:history) { create :history, historyable_type: 'Vacancy', historyable_id: vacancy.id }

  let(:history_sr) { create :history, historyable_type: 'StaffRelation', historyable_id: staff_relation.id  }

  context 'methods helper' do
    it 'method set_owner_for_historyable' do
      expect(helper.set_owner_for_historyable(history).html_safe).to eq("<a href=\"/users/#{vacancy.owner.id}\">#{vacancy.owner.full_name}</a>")
    end

    context 'set_action_for' do
      it 'method set_action_for VACATION' do
        #temp
        expect(helper.set_action_for(history).html_safe).to eq("<span class=\"translation_missing\" title=\"translation missing: ru.history.vacancy.notice, object_name: &lt;a href=&quot;http://test.host/vacancies/#{vacancy.id}&quot;&gt;Вакансия_#{vacancy.id}&lt;/a&gt;\">Notice</span>")
      end

      it 'method set_action_for STAFF_RELATION' do
        #temp
        expect(helper.set_action_for(history_sr).html_safe).to eq("<span class=\"translation_missing\" title=\"translation missing: ru.history.staff_relation.notice, vacancy_name: &lt;a href=&quot;/vacancies/#{history_sr.historyable.vacancy.id}&quot;&gt;Вакансия_#{history_sr.historyable.vacancy.id}&lt;/a&gt;, candidate_name: &lt;a href=&quot;/candidates/#{history_sr.historyable.candidate.id}&quot;&gt;#{history_sr.historyable.candidate.name}&lt;/a&gt;\">Notice</span>")
      end
    end

    # context 'set_status_for' do
    #   it 'method set_status_for' do
    #     expect(helper.set_status_for(history).html_safe).to eq("")
    #   end
    # end
  end
end
