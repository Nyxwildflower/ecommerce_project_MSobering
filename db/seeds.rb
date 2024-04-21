require "net/http"
require "json"

# Reusing this method from my intro project.
# This method takes a url for a request and returns the data in JSON format.
def request_data(url)
  uri = URI(url)
  api_key = ENV['API_KEY']

  headers = {"X-API-KEY" => api_key}

  response = Net::HTTP.get(uri, headers)
  formatted_response = JSON.parse(response)
end
