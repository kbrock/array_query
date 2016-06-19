require 'spec_helper'

describe ArraySearch::Query do
  describe "#initialize" do
    it "accepts an array" do
      a = [Person.new]
      as = described_class.new(a)
      expect(as.to_a).to eq(a)
    end
  end
end
