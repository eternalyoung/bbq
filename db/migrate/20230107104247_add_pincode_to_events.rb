class AddPincodeToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :pincode, :string
  end
end
