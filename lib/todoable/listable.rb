require 'todoable'
require_relative 'token'
require_relative 'item'
require_relative 'list'
require 'json'

# List wrapper and token creation calls
module Listable
  include Todoable

  def self.authenticate
    response = Todoable.token_call
    return nil unless response.code == '200' || response.code == '201'
    token_data = JSON.parse(response.body)
    token = Token.new(token_data['token'], token_data['expires_at'])
    token
  end

  def self.get_lists(token)
    uritail = ''
    action = 'GET'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.format_API_response(response, token, uritail, action)
    lists = []
    return success if success.instance_of? String
    success['lists'].each do |l|
      lists.push(List.new(l))
    end
    lists
  end

  def self.make_list(token, name)
    uritail = ''
    action = 'POST'
    body = { 'list' => { 'name' => name } }
    response = Todoable.make_request(uritail, token.token, body, action)
    success = Todoable.format_API_response(response, token, uritail, action, body)
    return success if success.instance_of? String
    list = List.new(success)
    list
  end

  # Returns array containing list objects or error string
  def self.make_lists(token, names)
    lists = []
    names.each do |name|
      result = Listable.make_list(token, name)
      lists.push(result)
    end
    lists
  end

  def self.get_list_from_id(token, id)
    uritail = "/#{id}"
    action = 'GET'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.format_API_response(response, token, uritail, action)
    return success if success.instance_of? String
    success['id'] = id
    list = List.new(success)
    list
  end

  # Returns array containing list objects or error string
  def self.get_lists_from_ids(token, ids)
    lists = []
    ids.each do |id|
      lists.push(Listable.get_list_from_id(token, id))
    end
    lists
  end

  # Returns true if successfully deleted
  def self.delete_list(token, list)
    uritail = "/#{list.id}"
    action = 'DELETE'
    # Delete all the items before deleting the list
    unless list.items.empty?
      list.items.each do |item|
        list.delete_item(token, item.id)
      end
    end
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.format_API_response(response, token, uritail, action)
    case success
    when '200', '201', '204'
      return true
    else
      return "Update failed #{response.code} #{response.message}"
    end
  end

  # Returns hash of deletion success status based on list ID
  def self.delete_lists(token, lists)
    success = {}
    lists.each do |list|
      id = list.id
      success [id] = Listable.delete_list(token, list)
    end
    success
  end
end
