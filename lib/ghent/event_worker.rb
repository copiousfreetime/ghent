require 'kjess'
module Ghent
  class EventWorker
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    def initialize
      @queue_publisher = KJess::Client.new( 'localhost' )
      async.process_mailbox
    end

    def queue_name
      "ghent_incoming"
    end

    def process_mailbox
      loop do
        msg = receive { |msg| true }
        info "#{self.class} processing event #{msg['id']}"
        queue_publisher.set( queue_name, msg.to_json )
      end
    end
  end
end
