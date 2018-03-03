require "todoable/Listable"
require 'spec_helper'

RSpec.describe "Listable" do
  include Listable
    let(:test_token) {Listable.authenticate}
    let(:list_id) {'a1edcc66-eba9-4e56-a125-b6978cd4082f'}

  describe '.authenticate' do
    it 'gets a token' do
      expect(test_token).to be_a Token
      end
    end
  def test_lists
    lists = Listable.get_lists(test_token)
    lists.each do |list|
    return false unless list.id.instance_of? String
  end

  describe '.get_lists(token)' do
    it 'gets all lists (assumes pre-existing lists)' do
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
    it 'gets a list from an existing ID' do
        list = list_from_id(list_id)
        expect(list).to be_a List
    end
    it 'returns an error string from an invalid ID' do
      list = list_from_id('Test_String')
      expect(list.to_s).to eq 'Failure.  Code received 404 message Not Found'
    end
  end
  describe '.get_lists_from_ids(token, ids)' do
    it 'returns valid lists and invalid strings for each id presented' do
      lists = lists_from_ids
      expect(lists[0]).to be_a List
      expect(lists[1].to_s).to eq 'Failure.  Code received 404 message Not Found'
    end
  end

  def list_create(name)
    list = Listable.make_list(test_token, name)
    list
  end
  describe '.make_list(token, name)'
    it 'creates a new list' do
      list = list_create("RSpec Test List")
      expect(list).to be_a List
    end
    it 'Returns an error when trying to create a pre-existing list' do
      list_create("RSpec Fail List1")
      list_fail = list_create("RSpec Fail List1")
      expect(list_fail).to eq '{\"name\":[\"has already been taken\"]}'
    end
end
