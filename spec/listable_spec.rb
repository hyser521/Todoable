require 'spec_helper'
describe List do
    let(:test_token) {List.authenticate}
    let(:list_id) {'ec0916ac-708e-4025-ba48-b146ff7f75a8'}
  describe '.authenticate' do
    context 'It gets a token' do
      expect(:test_token).to be_a Token
      end
    end
  def test_lists
    lists = get_lists(:test_token)
    lists.each do |list|
    return false unless list.id.instance_of? String
  end
  describe '.get_lists(token)' do
    context 'It gets all lists (assumes pre-existing lists)' do
            success = test_lists
            expect(success).to eq true
        end
    end
  end
  describe '.get_list_from_id(token, id)' do
    context 'It gets a list from an ID' do
        list = get_list_from_id(:test_token, :list_id)
        expect(list).to be_a List
    end
    context ''
  end
end
