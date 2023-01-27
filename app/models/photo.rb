class Photo < ApplicationRecord
  belongs_to :event
  belongs_to :user

  has_one_attached :photo do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :preview, resize_to_limit: [200, 200]
  end

  scope :persisted, -> { where 'id IS NOT NULL' }
end
