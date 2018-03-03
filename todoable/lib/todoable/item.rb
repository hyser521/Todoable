# more user friendly way to interact with items
# Makes immutable information immutable to user
class Item
  attr_reader :name, :id, :src, :finished_at
  def initialize(name, id, finished, src)
    @name = name
    @id = id
    @finished_at = finished
    @src = src
  end

  # marks item as finished. "Imma let you..."
  def mark_item_finished(token, list_id)
    uritail = '/' + list_id + '/items/' + @id + '/finish'
    action = 'PUT'
    response = Todoable.make_request(uritail, token.token, nil, action)
    success = Todoable.response_logic(response, token, uritail, action, nil)
    return success if success.instance_of? String
    @finished_at=item['finished_at']
    true
  end
end
