require 'sinatra'
require 'faraday'
require 'base64'
require 'json'

MAX_CONTENT_LENGTH = 100000
ALLOW_CONTENT_TYPES = ['image/jpeg', 'image/png', 'image/gif']

get '/' do
  'chatwork-allow-origin-proxy'
end

get '/v1/image.json' do
  return not_found unless params[:url]

  content_type :json

  conn = Faraday::Connection.new
  response = conn.head params[:url]

  status_code = response.status
  unless status_code == 200
    status status_code
    return { status: "status code #{status_code}" }.to_json
  end

  content_length = response.headers['content-length'].to_i
  unless MAX_CONTENT_LENGTH >= content_length
    status 500
    return { status: "request icon is too large. max: 100KB" }.to_json
  end

  content_type = response.headers['content-type']
  unless ALLOW_CONTENT_TYPES.include? content_type
    status 500
    return { status: "invalid content-type. allow: image/jpeg, image/png, image/gif" }.to_json
  end

  response = conn.get params[:url]

  body = response.body
  encoded_body = Base64.encode64 body

  data_url = "data:#{content_type};base64,#{encoded_body}"

  headers \
    "Access-Control-Allow-Origin" => "*",
    "Access-Control-Allow-Methods" => "GET"

  { status: :success, data: data_url }.to_json
end
