require 'uri'
require 'net/http'

module Commands
  class Push < SlackRubyBot::Commands::Base
    command 'push' do |client, data, _match|
      url  = URI("#{ENV['FM_BASE_URL']}/api/v1/links")
      http = Net::HTTP.new(url.host, url.port)

      request                  = Net::HTTP::Post.new(url)
      request['Content-Type']  = 'application/json'
      request['Authorization'] = "Bearer #{ENV['FM_ACCESS_TOKEN']}"
      exp                      = _match['expression'].rpartition(' ')

      request.body = {
        link: {
          title: exp.first,
          url: exp.last[1..-2]
        },
        user: client.users[data.user].profile.email
      }.to_json

      response = JSON.parse(http.request(request).read_body)

      client.say channel: data.channel, text: "#{response['message']} -> #{response['url']}"
    end
  end
end