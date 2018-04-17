require 'todoable'
require_relative 'listable'

#Item class
class Item
  attr_reader :name, :id, :src, :finished_at
  def initialize(name, id, finished, src)
    @name = name
    @id = id
    @finished_at = finished
    @src = src
  end

  def mark_item_finished(token, list_id)
    uritail = "/#{list_id}/items/#{@id}/finish"
    action = 'PUT'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.format_API_response(response, token, uritail, action, nil)
    case success
    when '200', '201', '204'
      # Provided Endpoint doesn't return an item hash in the response
      # so retrieving the item by grabbing the list and updating the local item
      # that way.
      list = Listable.get_list_from_id(token, list_id)
      item = list.items.select { |s| s.id == @id }
      @finished_at = item[0].finished_at
      return true
    else
      return "Update failed #{response.code} #{response.message}"
    end
  end
end
