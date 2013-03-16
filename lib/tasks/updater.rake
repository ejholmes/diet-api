namespace :updater do
  task :run => :environment do
    loop do
      feed = Feed.next
      puts "Updating #{feed.title}"
      feed.refresh!
      sleep 5
    end
  end
end
