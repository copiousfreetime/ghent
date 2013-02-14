module Ghent
  class PublicEventsPoller
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    attr_accessor :etag
    attr_accessor :poll_interval
    attr_accessor :timer

    def initialize
      @etag = ""
      @poll_interval = 5
      @timer         = nil
      @subscriber    = subscribe( topic, :event_response )
      reset_timer
      async.submit_poll_request
      info "#{self.class} Public Events Poller started"
    end

    def reset_timer
      if timer.nil? or (timer.interval != poll_interval) then
        self.timer = after( poll_interval ) { submit_poll_request }
      end
      info "#{self.class} resetting timer poll interval to #{timer.interval}"
      timer.reset
    end

    def topic
      "poll_response"
    end

    def event_response( _, response )
      self.etag          = response.headers['ETag']
      self.poll_interval = response.headers['X-Poll-Interval'].to_i / 10
      info "#{self.class} event_response etag '#{etag}' and poll_interval #{poll_interval}"
    end

    def api_actor
      loop do
        break if Celluloid::Actor[:api_request]
        sleep 1
      end
      Celluloid::Actor[:api_request]
    end

    def submit_poll_request
      r =  [ 'https://api.github.com/events', etag, topic ]
      info "#{self.class} sumitting request #{r.inspect}"

      api_actor.mailbox << r
      reset_timer
    end
  end
end
