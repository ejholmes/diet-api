class AddUnreadCounterCacheToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :unread_count, :integer, :null => false, :default => 0
    Feed.reset_column_information
    Feed.find_each do |feed|
      Feed.update_counters feed.id, :unread_count => feed.unread_items.count
    end
  end
end
