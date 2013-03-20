class AddReadabilityAccessTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :readability_access_token, :string
  end
end
