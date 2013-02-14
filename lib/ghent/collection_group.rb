require 'ghent/api_request'
require 'ghent/public_events_poller'

module Ghent
  class CollectionGroup < Celluloid::SupervisionGroup
    supervise ::Ghent::PublicEventsPoller, :as => :public_events_poller
    supervise ::Ghent::ApiRequest, :as => :api_request
  end
end
