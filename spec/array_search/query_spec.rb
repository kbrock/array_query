require 'spec_helper'

describe ArraySearch::Query do
  let(:peter) { person(%w(peter NY))}
  let(:joe) { person(%w(joe CA))}
  let(:joe2) { person(%w(joe NY))}
  let(:joe_and_peter) { [peter, joe] }

  describe "#initialize" do
    let(:c) { {:state => "CA"} }

    it "accepts a collection" do
      as = described_class.new(joe)
      expect(as.collection).to eq(joe)
      expect(as.conditions).to eq({}) # be_blank
    end

    # private api
    it "accepts conditions" do
      as = described_class.new(joe, c)
      expect(as.collection).to eq(joe)
      expect(as.conditions).to eq(c)
    end
  end

  describe "#except" do
    it "ignores where" do
      expect(pq([joe]).where(:state => "NV").except(:where).to_a).to eq([joe])
    end

    it "keeps where" do
      expect(pq([joe]).where(:state => "NV").except(:order).to_a).to eq([])
    end
  end

  # filtered is the private method responsible for conditions
  describe "#where", "#filtered" do
    it "filters to all records for nil conditions" do
      # and is a no op
      expect(pq(joe_and_peter).where().to_a).to equal(joe_and_peter)
    end

    it "filters to all records for empty conditions" do
      expect(pq(joe_and_peter).where({}).to_a).to equal(joe_and_peter)
    end

    it "filters to no people" do
      expect(pq(joe_and_peter).where(:state => "CAT").to_a).to eq([])
    end

    it "filters to some people" do
      expect(pq(joe_and_peter).where(:state => "CA").to_a).to eq([joe])
    end

    it "filters to all people for multi-condition" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR)).to_a).to eq(joe_and_peter)
    end

    it "filters to no people from multi-condition" do
      expect(pq(joe_and_peter).where(:state => %w(CANADA NH)).to_a).to eq([])
    end

    it "filters with multiple fields" do
      expect(pq(joe_and_peter).where(:state => %w(CA NY AR), :name => "joe").to_a).to eq([joe])
    end

    it "does not create new object for nop filter" do
      q = pq(joe_and_peter)
      expect(q.where(nil)).to equal(q)
      expect(q.where({})).to equal(q)
    end

    it "chains where" do
      expect(pq([joe, joe2, peter]).where(:state => %w(NY AR)).where(:name => "joe").to_a).to eq([joe2])
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
