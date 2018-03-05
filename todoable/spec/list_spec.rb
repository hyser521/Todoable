require "todoable/Listable"
require 'spec_helper'

RSpec.describe List do
  let (:test_token) {Listable.authenticate}
  describe '#change_name' do
    it 'changes a list\'s name', :vcr do
      list = Listable.make_list(test_token, 'Change Name List_1')
      expect(list.change_name(test_token, 'Change Name New Name List_1')).to eq true
      Listable.delete_list(test_token,list)
    end
  end

end
