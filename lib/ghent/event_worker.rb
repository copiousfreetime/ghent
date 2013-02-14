module Ghent
  class EventWorker
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    def initialize
      async.process_mailbox
    end

    def process_mailbox
      loop do
        msg = receive { |msg| true }
        info "#{self.class} processing event #{msg['id']}"
      end
    end
  end
end
