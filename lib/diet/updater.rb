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
            Librato.increment 'feed.refresh.count'
            Librato.timing 'feed.refresh.time' do
              feed.refresh!
            end
          rescue => e
            Librato.increment 'feed.refresh.failed.count'
            # Whatever
          end
        end
      end
    end

  private

    def log(*args)
      Diet.logger.info *args
    end

  end
end
