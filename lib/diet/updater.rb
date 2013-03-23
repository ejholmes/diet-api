module Diet
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
          log "Updating #{feed.title}"
          begin
            feed.refresh!
          rescue
            # Whatever
          end
        end
      end
    end

    def log(*args)
      Diet.logger.info *args
    end
  end
end
