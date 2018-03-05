require 'net/http'
require 'uri'
require 'json'

# Calls Todoable API
module Todoable
  # Method that actually touches the internet to get a token
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

  # Handles all request calls but the token get call.
  def self.make_request(uritail, token, body, action)
    uri = URI.parse('http://todoable.teachable.tech/api/lists' + uritail)
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
    request['Authorization'] = 'Token token="' + token + '"'
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

  def self.response_logic(response, token, uritail, action, body = nil)
    # Good responses or errors should return information to the user.
    json = response.body
    case response.code
    when '200', '201', '204'
      return JSON.parse(json) unless action == 'DELETE' || action == 'PUT' || action == 'PATCH'
      return response.code
    when '422'
      return json
    # Unauthorized Logic
    when '401'
      token = token.reauthenticate # attempt to get a new token

      return 'No token could be obtained' if token.nil?
      # try again and handle results
      response = Todoable.make_request(uritail, token.token, body, action)
      if !response.code == '200' || !response.code == '201'
        error = 'Failure.  Code received '
        return error + response.code + ' message ' + response.message
      end
      return JSON.parse(response.body)
    # Unknown code
    else
      error = 'Failure.  Code received '
      return error + response.code + ' message ' + response.message
    end
  end
end
