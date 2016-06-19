require 'spec_helper'

describe ArraySearch do
  describe ".wrap" do
    it "accepts an array of objects" do
      a = [Person.new]
      as = ArraySearch.wrap(a)
      expect(as).not_to eq(a)
      expect(as.to_a).to eq(a)
    end
  end
end
