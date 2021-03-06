require_relative 'item'
require 'todoable'

# List class models the database responses from the Todoable API
class List
  include Todoable
  attr_reader :id, :items, :src, :name

  def initialize(list)
    @name = list['name']
    @id = list['id']
    @src = list['src']
    @items = []
    unless list['items'].nil?
      list['items'].each do |item|
        @items.push(Item.new(item['name'], item['id'],
                             item['finished_at'], item['src']))
      end
    end
  end

  def change_name(token, new_name)
    uritail = "/#{@id}"
    action = 'PATCH'
    body = { 'list' => { 'name' => new_name } }
    response = Todoable.make_request(uritail, token.token, body, action)
    success = Todoable.format_API_response(response, token, uritail, action)
    case success
    when '200', '201', '204'
      @name = new_name
      return true
    else
      return "Update failed #{response.code} #{response.message}"
    end
  end

  def add_item(token, name)
    uritail = "/#{@id}/items"
    action = 'POST'
    body = { 'item' => { 'name' => name } }
    response = Todoable.make_request(uritail, token.token, body, action)
    failure = Todoable.format_API_response(response, token, uritail, action, body)
    return failure if failure.instance_of? String
    @items.push(Item.new(failure['name'], failure['id'],
                         failure['finished_at'], failure['src']))
    true
  end

  def delete_item(token, item_id)
    uritail = "/#{@id}/items/#{item_id}"
    action = 'DELETE'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.format_API_response(response, token, uritail, action)
    case success
    when '200', '201', '204'
      @items.delete_if do |item|
        item.id == item_id
      end
      return true
    else
      return "Update failed #{response.code} #{response.message}"
    end
  end
end
