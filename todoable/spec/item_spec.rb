require "todoable/Listable"
require 'spec_helper'

RSpec.describe Item do
    let(:test_token){Listable.authenticate}
  describe '#finish_item' do
    it 'marks an item as complete', :vcr do
      list = Listable.make_list(test_token, 'Item List_2')
      list.add_item(test_token, 'Item Test')
      expect(list.items[0].mark_item_finished(test_token, list.id)).to eq true
      Listable.delete_list(test_token, list)
    end
  end
end
