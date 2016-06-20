require 'spec_helper'

describe ArraySearch::Query do
  describe "#initialize" do
    let(:a) { [person(%w(joe CA))] }
    let(:c) { {:state => "CA"} }

    it "accepts a collection" do
      as = described_class.new(a)
      expect(as.collection).to eq(a)
      expect(as.conditions).to be {} # be_blank
    end

    # private api
    it "accepts conditions" do
      as = described_class.new(a, c)
      expect(as.collection).to eq(a)
      expect(as.conditions).to eq(c)
    end
  end

  # filtered is the private method responsible for conditions
  describe "#where", "#filtered" do
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
      expect(pq(joe_and_peter).where(:state => "CAT").to_a).to eq([])
    end

    it "filter includes some people" do
      expect(pq(joe_and_peter).where(:state => "CA").to_a).to eq([joe])
    end

    it "filter includes people from many states" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR)).to_a).to eq(joe_and_peter)
    end

    it "filter includes no people from many states" do
      expect(pq(joe_and_peter).where(:state => %w(CANADA NH)).to_a).to eq([])
    end

    it "supports multiple conditions" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR), :name => "joe").to_a).to eq([joe])
    end

    it "chains nil where" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR)).where(nil).to_a).to eq(joe_and_peter)
    end

    it "chains empty where" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR)).where({}).to_a).to eq(joe_and_peter)
    end

    it "chains where" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR)).where(:name => "joe").to_a).to eq([joe])
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
