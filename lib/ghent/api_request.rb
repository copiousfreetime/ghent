require 'httpclient'
require 'addressable/uri'
require 'netrc'

module Ghent
  class ApiRequest
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    attr_reader :client
    attr_reader :netrc

    def initialize
      @client  = ::HTTPClient.new
      @netrc   = ::Netrc.read
      async.process_mailbox
      info "#{self.class} started"
    end

    def headers_for( url, other = {} )
      user, password = netrc[url.host]
      { 'Authorization' => "#{user} #{password}" }.merge( other )
    end

    def process_mailbox
      loop do
        info "#{self.class} processing mailbox"
        msg                    = receive { |msg| true }
        url, etag, response_to = *msg
        url                    = ::Addressable::URI.parse( url )
        request_headers        = headers_for( url, 'If-None-Match' => etag )

        info "#{self.class} requesting #{url} ETag: #{etag}"

        response = client.get( url, nil, request_headers)
        info "#{self.class} sending #{response} (#{response.status_code}) to #{response_to}"
        info "#{self.class} Rate Limit #{response.headers['X-RateLimit-Remaining']}/#{response.headers['X-RateLimit-Limit']}"
        async.publish( response_to, [ url, etag, response ])
      end
    end
  end
end
