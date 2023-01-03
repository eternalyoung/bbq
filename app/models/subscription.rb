class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true
  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: /\A[\w_+.\-]+@[\w\-]+(\.[\w\-]+)*\.[a-zA-Z]+\Z/, unless: -> { user.present? }
  validates :user_email, uniqueness: { scope: :event_id }, unless: -> { user.present? }
  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }

  validate :event_creator_check, if: -> { user.present? }
  validate :email_check, unless: -> { user.present? }

  def user_name
    user.present? ? user.name : super
  end

  def user_email
    user.present? ? user.email : super
  end

  def event_creator_check
    errors.add(:user, :creator) if event.user == user
  end

  def email_check
    errors.add(:user_email, :already_registered) unless User.find_by(email: user_email).nil?
  end
end
