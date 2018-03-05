require "todoable/Listable"
require 'spec_helper'

RSpec.describe "Listable" do
  include Listable
    let(:test_token) {Listable.authenticate}
    let(:list_id) {'a1edcc66-eba9-4e56-a125-b6978cd4082f'}

  describe '.authenticate' do
    it 'gets a token', :vcr do
      test_token = Listable.authenticate
      expect(test_token).to be_a Token
      end
    end

  def test_lists
    lists = Listable.get_lists(test_token)
    lists.each do |list|
    return false unless list.id.instance_of? String
  end

  describe '.get_lists(token)' do
    it 'gets all lists (assumes pre-existing lists)', :vcr do
            success = test_lists
            expect(success).to eq true
        end
    end
  end

  def list_from_id(id)
      list = Listable.get_list_from_id(test_token, id)
      list
  end

  def lists_from_ids
      lists = Listable.get_lists_from_ids(test_token,[list_id, 'Bad_ID'])
      lists
  end

  describe '.get_list_from_id(token, id)' do
    it 'gets a list from an existing ID', :vcr do
        list = list_from_id(list_id)
        expect(list).to be_a List
    end
    it 'returns an error string from an invalid ID', :vcr do
      list = list_from_id('Test_String')
      expect(list.to_s).to eq 'Failure.  Code received 404 message Not Found'
    end
  end

  describe '.get_lists_from_ids(token, ids)' do
    it 'returns valid lists and invalid strings for each id presented', :vcr do
      lists = lists_from_ids
      expect(lists[0]).to be_a List
      expect(lists[1].to_s).to eq 'Failure.  Code received 404 message Not Found'
    end
  end

  def list_create(name)
    list = Listable.make_list(test_token, name)
    list
  end

  describe '.make_list(token, name)' do
    it 'creates a new list', :vcr do
      list = list_create("RSpec Test List_2")
      expect(list).to be_a List
    end
    it 'Returns an error when trying to create a pre-existing list', :vcr do
        list_create("RSpec Fail List3")
        list_fail = list_create("RSpec Fail List3")
        expect(list_fail).to be_a String
    end
  end

  describe '.make_lists(token, names)' do
    it 'creates new lists and returns errors', :vcr do
      lists = Listable.make_lists(test_token,
      ["RSpec Success_1", "RSpec Success_1"])
      expect(lists[0]).to be_a List
      expect(lists[1]).to be_a String
    end
  end

  describe '.delete_list(token, list)' do
    it 'deletes a list', :vcr do
      list = list_create('RSpec Delete List_2')
      expect(Listable.delete_list(test_token,list)).to eq true
    end
    it 'deletes a list and any attached items', :vcr do
      list= list_create('RSpec Delete List_1')
      list.add_item(test_token,'RSpec Delete Item')
      item_id = list.items[0].id
      expect(Listable.delete_list(test_token, list)).to eq true
      expect(list.delete_item(test_token, item_id)).to be_a String
    end
  end

end
