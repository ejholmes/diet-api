class Updater
  def self.run
    new.run
  end

  def initialize
    STDOUT.sync = true
  end

  def run
    loop do
      feed = Feed.next
      if feed
        puts "Updating #{feed.title}"
        feed.refresh!
      end
    end
  end
end
