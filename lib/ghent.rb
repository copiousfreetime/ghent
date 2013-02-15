module Ghent
  VERSION = "1.0.0"
end

require 'celluloid'
require 'logging'

require 'ghent/logable'
require 'ghent/api_request'
require 'ghent/events_splitter'
require 'ghent/events_trigger'
require 'ghent/event_worker'
require 'ghent/collection_group'
