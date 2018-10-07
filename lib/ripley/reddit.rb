require 'json'
require 'net/http'
require 'uri'

# #new - get an OAuth token to access the oauth.reddit.com API
# #count - get subscriber numbers for a subreddit
class Reddit
  def initialize(credentials:)
    @user_agent = credentials[:user_agent]
    response = token_request(
      uri: URI('https://www.reddit.com/api/v1/access_token'),
      credential_hash: credentials
    )
    @token = Reddit.parse_token_response(response: response)
  end

  # number of subscribers
  def count(lang:)
    resp = info_request(lang: lang)
    Reddit.parse_info_response(response: resp)
  end

  # private -- errors on token_body_hash...

  def info_request(lang:)
    uri = URI "https://oauth.reddit.com/r/#{lang}/about"
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |www|
      req = Net::HTTP::Get.new uri
      req.add_field 'Authorization', 'bearer ' + @token
      req['User-Agent'] = @user_agent
      www.request req
    end
  end

  def token_request(uri:, credential_hash:)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |www|
      req = Net::HTTP::Post.new uri
      req.basic_auth credential_hash[:client_id],
                     credential_hash[:client_secret]
      req['Content-Type'] = 'application/x-www-form-urlencoded'
      req['User-Agent'] = @user_agent
      req.set_form_data Reddit.token_body_hash(credential_hash: credential_hash)
      www.request req
    end
  end

  def self.parse_info_response(response:)
    if response.is_a? Net::HTTPSuccess
      data = JSON.parse response.body
      data['data']['subscribers']
    else
      puts "Error - #{lang}: #{response.message}"
      0
    end
  end

  def self.parse_token_response(response:)
    if response.is_a? Net::HTTPSuccess
      token = JSON.parse response.body
      token['access_token']
    else
      puts "OAuth failure: #{response.message}"
    end
  end

  def self.token_body_hash(credential_hash:)
    { 'device_id' => credential_hash[:device_id],
      'grant_type' => 'client_credentials',
      'password' => credential_hash[:password],
      'redirect_uri' => credential_hash[:redirect_uri] }
  end
end
