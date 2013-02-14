require 'lru'
module Ghent
  # Actor that consumes the body of a response and processes the events. It may
  # or may not kick off other events based upon that result. It will split the
  # full response into events that have not been seen before and append them to 
  # the event consumer.
  class PublicEventsSplitter
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    def topics 
      %w[ head_response next_response ]
    end

    def intiialize
      @lru = Cache::LRU.new( 10_000 )
      topics.each do |t|
        subscribe( t, :process_response )
      end
    end

    def public_event_worker
      loop do
        break if Celluloid::Actor[:public_event_worker]
        sleep 1
      end
      Celluloid::Actor[:public_event_worker]
    end

    def process_response( _, response )


    end

  end
 
