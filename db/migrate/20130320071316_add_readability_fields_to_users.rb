class AddReadabilityFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :readability, :string
  end
end
