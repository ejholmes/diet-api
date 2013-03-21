class AddPasswordToUsers < ActiveRecord::Migration
  def up
    add_column :users, :password, :string
    remove_column :users, :token
  end
end
