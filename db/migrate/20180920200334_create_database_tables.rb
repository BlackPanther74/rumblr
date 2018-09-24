class CreateDatabaseTables < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |table|
      table.string :username
      table.string :password
      table.datetime :birthday
      table.timestamps
    end

    create_table :posts do |table|
      table.string :title
      table.text :content
      table.references :user
      table.timestamps 
    end

    create_table :comments do |table|
      table.string :content
      table.references :user
      table.references :post
      table.timestamps 
    end
  end
end
