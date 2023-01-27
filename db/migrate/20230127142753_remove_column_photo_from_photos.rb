class RemoveColumnPhotoFromPhotos < ActiveRecord::Migration[7.0]
  def change
    remove_column :photos, :photo, :string
  end
end
