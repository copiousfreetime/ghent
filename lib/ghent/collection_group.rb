require 'ghent/api_request'
require 'ghent/public_events_trigger'
require 'ghent/public_events_splitter'

module Ghent
  class CollectionGroup < Celluloid::SupervisionGroup
    supervise ::Ghent::PublicEventsTrigger, :as => :public_events_trigger
    supervise ::Ghent::PublicEventsSplitter, :as => :public_events_splitter
    supervise ::Ghent::ApiRequest, :as => :api_request
  end
end
