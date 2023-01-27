require 'open-uri'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, length: { maximum: 35 }

  before_validation :set_name, on: :create
  after_commit :link_subscriptions, on: :create

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :full, resize_to_limit: [300, 300]
  end

  def self.find_for_oauth(access_token)
    email = access_token.info.email.downcase
    user = where(email: email).first

    return user if user.present?

    provider = access_token.provider
    id = access_token.uid
    url = case provider
          when 'vkontakte' then "https://vkontakte.com/id#{id}"
          when 'github' then "https://github.com/users/#{id}"
          end
    image = URI.open(access_token.info.image)

    where(url: url, provider: provider).first_or_create! do |user|
      user.email = email
      user.password = Devise.friendly_token.first(16)
      user.name = case provider
                  when 'vkontakte' then access_token.info.first_name
                  when 'github' then access_token.info.nickname
                  end
      user.avatar.attach(io: image, filename: 'avatar', content_type: image.content_type)
    end
  end

  private

  def set_name
    self.name = "Аноним ##{rand(9999)}" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email)
      .update_all(user_id: self.id)
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
