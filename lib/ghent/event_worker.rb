require 'kjess'
module Ghent
  class EventWorker
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    attr_reader :kclient

    def initialize
      @kclient = KJess::Client.new
      async.process_mailbox
    end

    def queue_name
      "ghent_incoming"
    end

    def queue( msg )
      kclient.set( queue_name, msg )
    end

    def process_mailbox
      loop do
        msg = receive { |msg| true }
        #debug "#{self.class} processing event #{msg['id']}"
        queue( msg.to_json )
      end
    end
  end
end
