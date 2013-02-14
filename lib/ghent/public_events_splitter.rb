require 'lru'
require 'json'
require 'link_header'

module Ghent
  # Actor that consumes the body of a response and processes the events. It may
  # or may not kick off other events based upon that result. It will split the
  # full response into events that have not been seen before and append them to 
  # the event consumer.
  class PublicEventsSplitter
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    attr_reader :lru

    def topics 
      %w[ head_response next_response ]
    end

    def initialize
      @lru = Cache::LRU.new( :max_elements => 1000 )
      topics.each do |t|
        subscribe( t, :split_response )
        info "#{self.class} subscribe to #{t} via :split_response"
      end
    end

    def public_event_worker
      loop do
        break if Celluloid::Actor[:public_event_worker]
        sleep 1
      end
      Celluloid::Actor[:public_event_worker]
    end

    def api_actor
      loop do
        break if Celluloid::Actor[:api_request]
        sleep 1
      end
      Celluloid::Actor[:api_request]
    end

    def added_events( events )
      ne = []
      events.each do |event|
        next if lru.get( event['id'] )
        lru.put( event['id'], true )
        ne << event['id'] 
      end
      return ne
    end

    def split_response( _, response )
      events = JSON.parse( response.body )
      info "#{self.class} splitting response from #{_}"
      aevents = added_events( events )
      info "#{self.class} added #{aevents.size} to lru which now has size #{lru.size}"
      submit_next_request( response.headers ) unless aevents.empty?
    end

    def submit_next_request( headers )
      link_header_text = headers['Link']
      return unless link_header_text
      etag = headers['ETag']
      link = LinkHeader.parse( link_header_text )

      if nlink = link.find_link( %w[ rel next ] ) then
        r =  [ nlink.href, etag, :next_response ]
        info "#{self.class} submitting request for #{r}"
        api_actor.mailbox << r
      end
    end
  end
end 
