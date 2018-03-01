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
  def self.finish(item, finished_at)
    item.finish = finished_at
  end
end
