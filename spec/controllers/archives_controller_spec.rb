require 'rails_helper'

RSpec.describe ArchivesController, type: :controller do

  let(:user) { create(:user) }
  let(:deleted_sticker) { create :deleted_sticker }
  let(:deleted_vacancy) { create :deleted_vacancy }

  before { sign_in user }

  describe 'should have the list os deleted objects' do
    context 'should have the list os deleted stickers' do
      it 'should have the list os deleted stickers' do
        get :index, params: { object_name: 'stickers' }
        expect(Sticker.only_deleted).to eq([deleted_sticker])
      end

      it 'should restore deleted sticker' do
        delete :destroy, params: { object_name: 'stickers', id: deleted_sticker }
        expect(Sticker.only_deleted.count).to eq 0
        expect(Sticker.only_deleted).to eq([])
      end
    end

    context 'should have the list os deleted vacancies' do
      it 'should have the list os deleted vacancies' do
        get :index, params: { object_name: 'vacancies' }
        expect(Vacancy.only_deleted).to eq([deleted_vacancy])
      end

      it 'should restore deleted vacancy' do
        delete :destroy, params: { object_name: 'vacancies', id: deleted_vacancy }
        expect(Vacancy.only_deleted.count).to eq 0
        expect(Vacancy.only_deleted).to eq([])
        expect(assigns(:object).status).to eq 'Не задействована'
        expect(flash[:notice]).to eq 'Объект был успешно восстановлен.'
      end
    end
  end

end