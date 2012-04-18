$:.unshift File.dirname(__FILE__) + '/../../../'

require 'rubygems'
require 'redis'
require 'lib/redwatch/twitter/twitter_stream'

module Redwatch

  class TwitterReader
    attr_accessor :config
    
    def initialize
      @redis = Redis.new(:host => "localhost", :port => 6379)
    end

    def start
      stream = TwitterStream.new(:path => '/1/statuses/sample.json', :auth => 'stream_test:k!rkl@nd')
                  
      puts("twitter reader starting")

      stream.on_item {|item| @redis.rpush("twitter_stream", item)}
      stream.on_error {|message| puts("stream error=#{message}")}
      stream.on_failure {|message| puts("stream failure=#{message}")}
      stream.on_reconnect {|timeout, retries| puts("stream reconnect timeout=#{timeout}, retries=#{retries}")}

      puts("opening stream connection")      
      stream.run
    end     
  end
end

Redwatch::TwitterReader.new.start