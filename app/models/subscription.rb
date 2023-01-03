class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: /\A[\w_+.\-]+@[\w\-]+(\.[\w\-]+)*\.[a-zA-Z]+\Z/, unless: -> { user.present? }

  # для данного event_id один юзер может подписаться только один раз (если юзер задан)
  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }

  # для данного event_id один email может использоваться только один раз (если нет юзера, анонимная подписка)
  validates :user_email, uniqueness: { scope: :event_id }, unless: -> { user.present? }

  validate :event_creator_check, if: -> { user.present? }

  validate :email_check, unless: -> { user.present? }

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  # переопределяем метод, если есть юзер, выдаем его email,
  # если нет -- дергаем исходный переопределенный метод
  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  def event_creator_check
    errors.add(:user, :creator) if event.user == user
  end

  def email_check
    errors.add(:user_email, :already_registered) unless User.find_by(email: user_email).nil?
  end
end
