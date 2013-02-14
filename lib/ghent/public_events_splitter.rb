module Ghent
  # Actor that consumes the body of a response and processes the events. It may
  # or may not kick off other events based upon
  class PublicEventsSplitter
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    attr_accessor :etag
    attr_accessor :poll_interval
    attr_accessor :timer

 
