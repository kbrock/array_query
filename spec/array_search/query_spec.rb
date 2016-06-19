require 'spec_helper'

describe ArraySearch::Query do
  describe "#initialize" do
    it "accepts an array" do
      a = [person(%w(joe CA))]
      as = described_class.new(a)
      expect(as.to_a).to eq(a)
    end

    # private api
    it "accepts a condition" do

    end
  end

  describe "#where" do
    let(:peter) { person(%w(peter NY))}
    let(:joe) { person(%w(joe CA))}
    let(:joe_and_peter) { [peter, joe] }
    it "returns all records for nil" do
      expect(pq(joe_and_peter).where().to_a).to eq(joe_and_peter)
    end

    it "returns all records for empty conditions" do
      expect(pq(joe_and_peter).where().to_a).to eq(joe_and_peter)
    end

    it "filter removes all people" do
      expect(pq(joe_and_peter).where(:state => "AR").to_a).to eq([])
    end

    it "filter includes some people" do
      expect(pq(joe_and_peter).where(:state => "CA").to_a).to eq([joe])
    end

    it "filter includes people from many states" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR)).to_a).to eq(joe_and_peter)
    end
  end

  # people query
  def pq(people)
    people = [people] unless people.kind_of?(Array)
    described_class.new(people)
  end

  def person(name_state)
    Person.new(*name_state)
  end
end
