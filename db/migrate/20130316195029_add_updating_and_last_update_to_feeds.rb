class AddUpdatingAndLastUpdateToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :updating, :boolean, :default => false
    add_column :feeds, :last_update, :datetime
  end
end
