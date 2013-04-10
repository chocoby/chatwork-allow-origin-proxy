require 'sinatra'
require 'faraday'
require 'base64'
require 'json'

get '/' do
  'chatwork-allow-origin-proxy'
end

get '/v1/icon.json' do
  # TODO: content type (20KB)
  # TODO: content length (jpeg/gif/png)

  return not_found unless params[:url]

  conn = Faraday::Connection.new
  response = conn.get params[:url]

  unless response.status == 200
    status response.status
    return { status: "status code #{response.status}" }.to_json
  end

  content_type = response.headers['content-type']
  body = response.body

  encoded_body = Base64.encode64 body

  data_url = "data:#{content_type};base64,#{encoded_body}"

  headers \
    "Access-Control-Allow-Origin" => "*",
    "Access-Control-Allow-Methods" => "GET"

  { status: :success, data: data_url }.to_json
end
