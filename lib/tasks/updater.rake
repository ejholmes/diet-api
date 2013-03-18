namespace :updater do
  task :run => :environment do
    STDOUT.sync = true
    loop do
      feed = Feed.next
      if feed
        puts "Updating #{feed.title} for #{feed.user.email}"
        feed.refresh!
      end
      sleep 5
    end
  end
end
