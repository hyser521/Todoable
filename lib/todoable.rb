require 'net/http'
require 'uri'
require 'json'

# Calls database API and formats response for processing
module Todoable

  def self.token_call
    uri = URI.parse('http://todoable.teachable.tech/api/authenticate')
    request = Net::HTTP::Post.new(uri)
    request.basic_auth('eric.m.lew@gmail.com', 'todoable')
    request.content_type = 'application/json'
    request['Accept'] = 'application/json'
    req_options =
      {
        use_ssl: uri.scheme == 'https'
      }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response
  end

  def self.make_request(uritail, token, body, action)
    uri = URI.parse("http://todoable.teachable.tech/api/lists#{uritail}")
    case action
    when 'GET'
      request = Net::HTTP::Get.new(uri)
    when 'POST'
      request = Net::HTTP::Post.new(uri)
    when 'DELETE'
      request = Net::HTTP::Delete.new(uri)
    when 'PATCH'
      request = Net::HTTP::Patch.new(uri)
    when 'PUT'
      request = Net::HTTP::Put.new(uri)
    end
    request.content_type = 'application/json'
    request['Authorization'] = 'Token token="#{token}"'
    request['Accept'] = 'application/json'
    request.body = JSON.dump(body)
    req_options =
      {
        use_ssl: uri.scheme == 'https'
      }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response
  end

  def self.format_API_response(response, token, uritail, action, body = nil)

    json = response.body
    case response.code
    when '200', '201', '204'
      unless action == 'DELETE' || action == 'PUT' || action == 'PATCH'
        return JSON.parse(json)
      else
        return response.code
      end
    when '422'
      return json
    # Retry when unauthorized.
    when '401'
      token = token.reauthenticate
      return 'No token could be obtained' if token.nil?
      response = Todoable.make_request(uritail, token.token, body, action)
      if !response.code == '200' || !response.code == '201'
        return "Failure.  Code received #{response.code} message #{response.message}"
      end
      return JSON.parse(response.body)
    else
      return "Failure.  Code received #{response.code} message #{response.message}"
    end
  end
end
