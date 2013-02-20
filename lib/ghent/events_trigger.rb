module Ghent
  # Actor that triggers an initial top level event polling request.
  # It subscribes to the responses it sends so that it may update the ETag value
  # and so it may update its timer interval so it does't get us in trouble with
  # GitHub.
  class EventsTrigger
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
      info "#{self.class} started"
    end

    # Internal: Reset the Timer so that it fires at the proper interval.
    def reset_timer
      if timer.nil? or (timer.interval != poll_interval) then
        self.timer = after( poll_interval ) { submit_poll_request }
      end
      info "#{self.class} resetting timer poll interval to #{timer.interval}"
      timer.reset
    end

    def topic
      "head_response"
    end

    # Internal: subscription calback, this is invoked when the ApiRequest has
    # finished with the request and sends us the response so we can update our
    # parameters.
    def event_response( _, msg)
      req_url, req_etag, response = *msg

      self.etag           = response.headers['ETag']
      self.poll_interval  = response.headers['X-Poll-Interval'].to_i
      info "#{self.class} event_response etag '#{etag}' and poll_interval #{poll_interval}"
    end

    # Internal:
    # Get the ApiRequest Actor, and make sure it exists before you return it.
    def api_actor
      loop do
        break if Celluloid::Actor[:api_request]
        sleep 1
      end
      Celluloid::Actor[:api_request]
    end

    # Submit a poll request, this is triggered by th timer. This submits a
    # request to the ApiRequest Actor.
    def submit_poll_request
      r =  [ 'https://api.github.com/events', etag, topic ]
      info "#{self.class} sumitting request #{r.inspect}"

      api_actor.mailbox << r
      reset_timer
    end
  end
end
