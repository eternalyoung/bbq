require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do
  subject { described_class }
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  permissions :edit?, :update?, :destroy? do
    context 'when user is not owner' do
      it 'denies access' do
        expect(subject).not_to permit(user, event)
      end
    end

    context 'when user is owner' do 
      let(:event) { create(:event, user: user) }

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
      let(:cookies) { ActionDispatch::Cookies::CookieJar.new(nil) }

      context 'and user is owner' do
        let(:event) { create(:event, pincode: '777', user: user) }

        it 'grants access' do
          expect(subject).to permit(user, event)
        end
      end

      context 'and pincode is incorrect' do
        let(:user) { UserContext.new(create(:user), { pincode: '', cookies: cookies }) }

        it 'denies access' do
          expect(subject).not_to permit(user, event)
        end
      end

      context 'and pincode is correct' do
        let(:user) { UserContext.new(create(:user), { pincode: '777', cookies: cookies }) }

        it 'grants access' do
          allow(user.params[:cookies]).to receive(:permanent).and_return({ "events_#{event.id}_pincode" => '' })
          expect(subject).to permit(user, event)
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
