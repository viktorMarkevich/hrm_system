describe 'Managing companies', type: :feature do
  let(:user) { create(:user) }
  let(:history_event) { create(:invalid_history_event) }
  let(:history_event1) { create(:history_event) }

  before do
    history_event
    history_event1
    sign_in_as(user, nil)
  end
  scenario 'show history_event' do
    visit organisers_path
    expect(page).to have_content 'Примечание'
  end
end