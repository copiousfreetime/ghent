require 'ghent/api_request'
require 'ghent/events_trigger'
require 'ghent/events_splitter'

module Ghent
  class CollectionGroup < Celluloid::SupervisionGroup
    supervise ::Ghent::EventsTrigger,  :as => :events_trigger
    supervise ::Ghent::EventsSplitter, :as => :events_splitter
    supervise ::Ghent::EventWorker, :as => :event_worker
    supervise ::Ghent::ApiRequest, :as => :api_request
  end
end
