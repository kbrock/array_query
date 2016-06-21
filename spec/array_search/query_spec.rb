require 'spec_helper'

describe ArraySearch::Query do
  let(:peter) { person(%w(peter NY))}
  let(:joe) { person(%w(joe CA))}
  let(:joe2) { person(%w(joe NY))}
  let(:joe_and_peter) { [peter, joe] }
  let(:ord_st) { %w(state) }

  describe "#initialize" do
    let(:c) { {:state => "CA"} }

    it "accepts a collection" do
      as = described_class.new(joe)
      expect(as.collection).to eq(joe)
      expect(as.conditions).to eq({}) # be_blank
      expect(as.ordering).to eq([]) # be_blank
    end

    # private api
    it "accepts conditions" do
      as = described_class.new(joe, c)
      expect(as.conditions).to eq(c)
    end

    it "accepts ordering" do
      as = described_class.new(joe, c, ord_st)
      expect(as.ordering).to eq(ord_st)
    end
  end

  describe "#except" do
    it "ignores where" do
      expect(pq(joe_and_peter).where(:state => "NV").except(:where).to_a).to equal(joe_and_peter)
    end

    it "keeps where" do
      expect(pq([joe, peter, joe2]).order(%w(name)).where(:state => "NY").except(:order).to_a).to eq([peter, joe2])
    end

    it "ignores order" do
      expect(pq(joe_and_peter).order(ord_st).except(:order).to_a).to equal(joe_and_peter)
    end

    it "keeps order" do
      expect(pq(joe_and_peter).order(ord_st).except(:where).to_a).to eq([joe, peter])
    end

    it "ignores multiple" do
      expect(pq(joe_and_peter).where(:state => "NV").order(%w(name)).except(:where, :order).to_a).to equal(joe_and_peter)
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

    # TODO: doesn't loose order / others
  end

  describe "#order", "#ordered" do
    it "skips sorting for noop order" do
      expect(pq(joe_and_peter).order(nil).to_a).to equal(joe_and_peter)
    end

    it "keeps same query for a no-op sort" do
      q = pq(joe_and_peter)
      expect(q.order(nil)).to equal(q)
    end

    it "sorts by a single field (not array)" do
      expect(pq(joe_and_peter).order("state").to_a).to eq([joe, peter])
    end

    it "sorting by a field" do
      expect(pq(joe_and_peter).order(ord_st).to_a).to eq([joe, peter])
    end

    it "sorting by many fields" do
      expect(pq([peter, joe2, joe]).order([:state, :name]).to_a).to eq([joe, joe2, peter])
    end

    it "sorts by multiple calls" do
      expect(pq([peter, joe2, joe]).order(:state).order(:name).to_a).to eq([joe, joe2, peter])
    end

    # TODO: doesn't loose where / others
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
