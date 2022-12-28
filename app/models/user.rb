class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Юзер может создавать много событий
  has_many :events

  # У юреза должно быть имя не длиннее 35 букв
  validates :name, presence: true, length: { maximum: 35 }

  before_validation :set_name, on: :create

  private

  # Задаем юзеру случайное имя, если оно пустое
  def set_name
    self.name = "Аноним ##{rand(9999)}" if self.name.blank?
  end
end

