class User < ApplicationRecord
  # Юзер может создавать много событий
  has_many :events

  # У юреза должно быть имя не длиннее 35 букв
  validates :name, presence: true, length: { maximum: 35 }

  # У юзера должен быть уникальный email по заданному шаблону не длиннее 255
  # символов
  validates :email, presence: true, length: { maximum: 255 }
  validates :email, uniqueness: true
  validates :email, format: /\A[\w_+.\-]+@[\w\-]+(\.[\w\-]+)*\.[a-zA-Z]+\Z/
end
