require 'json'

module Redwatch
  class ExtractHashtagsBolt < RedStorm::SimpleBolt
    output_fields :hashtag

    on_receive do |tuple|
      hashtags = tuple.getString(0).split.select{|w| w[0] == 35 && w.size > 2}.map{|w| [w]}
      hashtags.empty? ? nil : hashtags
    end
  end
end