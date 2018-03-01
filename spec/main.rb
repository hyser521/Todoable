require_relative "List"
require_relative "Token"

token = List.authenticate()

#retrieve all lists
lists = List.get_lists(token)
lists.each do |list|
  puts list.name
  list = List.get_list_from_id(token, list.id)
  if list.items.length > 0
    list.items.each do |item|
    puts "  " + item.name
    end
  end
end

# make items
#list = List.get_list_from_id(token, lists[0].id)
#list.add_item(token, list.id, 'item 2')
#list.mark_item_finished(token, list.id, list.items[0])
#list.items.each do |item|
  #puts item.name
#end
#list.delete_item(token, list, list.items[0].id)
#list.items.each do |item|
#  puts item.name
#end
#puts lists[0].id, lists[0].items[0].finished_at
# make list
#test = ["List Object Test6",{"list" =>{"name" =>"List Object Test5"}}]
#new_list = List.make_lists(token, test)
#puts new_list



#change name
#response = lists[0].change_name(token, "New!!!")
#puts lists[0].name

#retrieve some lists
#ids= [lists[0].id,lists[1].id]
#success = List.get_lists_from_ids(token, ids)
#puts success

#delete list
#puts lists[0].name
#success = List.delete_list(token,lists[0])
#puts success
#lists = List.get_lists(token)
#puts lists[0].name
