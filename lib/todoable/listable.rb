require 'Todoable'
require_relative 'Token'
require_relative 'Item'
require_relative 'List'
require 'json'

# API.  Uses containers to hold information.
module Listable
  include Todoable
  # Token methods
  # Get a token to complete Transactions.
  def self.authenticate
    response = Todoable.token_call
    return nil unless response.code == '200' || response.code == '201'
    token_data = JSON.parse(response.body)
    token = Token.new(token_data['token'], token_data['expires_at'])
    token
  end

  # List methods
  # retrieves all the Lists from Todoable server.
  def self.get_lists(token)
    uritail = ''
    action = 'GET'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.response_logic(response, token, uritail, action)
    lists = []
    return success if success.instance_of? String
    success['lists'].each do |l|
      lists.push(List.new(l))
    end
    lists
  end

  # Creates a List for this user.
  def self.make_list(token, name)
    uritail = ''
    action = 'POST'
    body = { 'list' => { 'name' => name } }
    response = Todoable.make_request(uritail, token.token, body, action)
    success = Todoable.response_logic(response, token, uritail, action, body)
    return success if success.instance_of? String
    list = List.new(success)
    list
  end

  # Creates multiple lists from string array.
  # Returns successful objects or error string
  def self.make_lists(token, names)
    lists = []
    names.each do |name|
      result = Listable.make_list(token, name)
      lists.push(result)
    end
    lists
  end

  # Gets a single list object for a user
  def self.get_list_from_id(token, id)
    uritail = '/' + id
    action = 'GET'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.response_logic(response, token, uritail, action)
    return success if success.instance_of? String
    success['id'] = id
    list = List.new(success)
    list
  end

  # From an array of IDs, gets the list for each one and returns a list/error
  def self.get_lists_from_ids(token, ids)
    lists = []
    ids.each do |id|
      lists.push(Listable.get_list_from_id(token, id))
    end
    lists
  end

  # Delete list.  Returns true if successfully deleted
  def self.delete_list(token, list)
    uritail = '/' + list.id
    action = 'DELETE'
    # Delete all the items before deleting the list
    unless list.items.empty?
      list.items.each do |_item|
        list.delete_item(token, list, item_id)
      end
    end
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.response_logic(response, token, uritail, action)
    case success
    when '200', '201', '204'
      return true
    else
      return 'Update failed ' + response.code + ' ' + response.message
    end
  end



  # Mark an item as finished
  def self.mark_item_finished(token, list_id, item)
    uritail = '/' + list_id + '/items/' + item.id + '/finish'
    action = 'PUT'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.response_logic(response, token, uritail, action, nil)
    return success if success.instance_of? String
    Item.finish(item, item['finished_at'])
    true
  end
end
