require 'twitter/json_stream'
require 'json'
require 'em-websocket-client'

class String
  def valid?
    blacklist = %w(que you for and the via that with del con like yes por this para our from una has your los las just have are did will want out when was can)
    self.size > 2 && !blacklist.include?(self.downcase)
  end
end

EventMachine::run {
  freq = Hash.new 0
  count = 0
  stream = Twitter::JSONStream.connect(
    :path    => '/1.1/statuses/filter.json?track=locations=-100.5,25,-100,26',
    :auth    => '*user*:*pwd*',
  )
  conn = EventMachine::WebSocketClient.connect 'ws://localhost:4567'

  stream.each_item do |item|
    begin
      count += 1
      tweet = JSON.load item
      words = tweet['text'].split(/\s/).select { |word| word =~ /^[@,#,a-zA-Z][A-Za-z]*\.?$/ }
      words.each do |word|
        freq[word] += 1 if word.valid?
      end
      if count == 50
        trending = freq.sort_by { |k, v| v }.last 20
        conn.send_msg JSON.dump(trending)
        count = 0
      end
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end
  end
}
