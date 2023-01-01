class Event < ApplicationRecord
  # Событие принадлежит юзеру
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many :subscribers, through: :subscriptions, source: :user
  # Юзера не может не быть. Обратите внимание, что в rails 5 связи валидируются
  # по умолчанию
  validates :user, presence: true

  # Заголовок должен быть, и не может быть длиннее 255 букв
  validates :title, presence: true, length: { maximum: 255 }

  # Также у события должны быть заполнены место и время проведения
  validates :address, presence: true
  validates :datetime, presence: true
end
