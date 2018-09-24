class CreateProfileTable < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |table|
    table.string :first_name
    table.string :last_name
    table.string :gender
    table.datetime :birthday
    table.string :email
    table.string :phone
    table.references :user
    table.timestamps
  end

  remove_column :users, :birthday, :datetime
  end
end
