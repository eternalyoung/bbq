require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  subject { described_class }
  let(:cookies) { ActionDispatch::Cookies::CookieJar.new(nil) }
  let(:user) { UserContext.new(create(:user), { pincode: '', cookies: cookies }) }
  let(:event) { create(:event) }

  permissions :edit?, :update?, :destroy? do
    context 'when user is not owner' do
      it 'denies access' do
        expect(subject).not_to permit(user, event)
      end
    end

    context 'when user is owner' do
      let(:event) { create(:event, user: user.user) }

      it 'grants access' do
        expect(subject).to permit(user, event)
      end
    end
  end

  permissions :show? do
    context 'when events pincode is blank' do
      it 'grants access' do
        expect(subject).to permit(user, event)
      end
    end

    context 'when pincode is not blank' do
      let(:event) { create(:event, pincode: '777') }

      context 'and user is owner' do
        let(:event) { create(:event, pincode: '777', user: user.user) }

        it 'grants access' do
          expect(subject).to permit(user, event)
        end
      end

      context 'and pincode is incorrect' do
        it 'denies access' do
          expect(subject).not_to permit(user, event)
        end
      end

      context 'and cookies pincode is correct' do
        let(:user) { UserContext.new(create(:user), { pincode: '', cookies: cookies }) }

        it 'grants access' do
          allow(user.params[:cookies]).to receive(:permanent).and_return({ "events_#{event.id}_pincode" => '777' })
          expect(subject).to permit(user, event)
        end
      end
    end
  end
end
