module Diet
  class Updater
    def self.run
      new.run
    end

    def initialize
      STDOUT.sync = true
    end

    def run
      loop { Feed.next.refresh! rescue nil }
    end
  end
end
