require "todoable/Listable"
require 'spec_helper'

RSpec.describe "Listable" do
  include Listable
    let(:test_token) {Listable.authenticate}
    let(:list_id) {'ec0916ac-708e-4025-ba48-b146ff7f75a8'}

  describe '.authenticate' do
    it 'It gets a token' do
      expect(:test_token).to be_a Token
      end
    end
  def test_lists
    lists = Listable.get_lists(:test_token)
    lists.each do |list|
    return false unless list.id.instance_of? String
  end

  describe '.get_lists(token)' do
    it 'It gets all lists (assumes pre-existing lists)' do
            success = test_lists
            expect(success).to eq true
        end
    end
  end
  def list_from_id(id)
      list = Listable.get_list_from_id(:test_token, id)
      list
  end
  def lists_from_ids
      lists = Listable.get_lists_from_ids(:test_token,[:list_id, 'Bad ID'])
      lists
  end
  describe '.get_list_from_id(token, id)' do
    it 'It gets a list from an existing ID' do
        list = list_from_id(:list_id)
        expect(list).to be_a List
    end
    it 'It returns an error string from an invalid ID' do
      list = list_from_id('Test String')
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
end
