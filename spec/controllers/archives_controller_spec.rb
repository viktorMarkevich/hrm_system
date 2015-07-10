require 'rails_helper'

RSpec.describe ArchivesController, type: :controller do
  let(:user) { create(:user) }
  let(:deleted_sticker) { create :deleted_sticker }

  before { sign_in user }

  describe 'should have the list os deleted objects' do
    context 'should have the list os deleted stickers' do
      it 'should have the list os deleted stickers' do
        get :index, object_name: 'stickers'
        expect(Sticker.only_deleted).to eq([deleted_sticker])
      end

      it 'should restore deleted sticker' do
        delete :destroy, object_name: 'stickers', id: deleted_sticker
        expect(Sticker.only_deleted.count).to eq 0
        expect(Sticker.only_deleted).to eq([])
      end
    end
  end
end
