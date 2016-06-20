module ArraySearch
  class Query
      @collection = collection
      @conditions = conditions || {}
    attr_accessor :collection, :conditions

    def initialize(c, conds = nil)
      @collection = c
      @conditions = conds || {}
    end

    def where(conds = nil)
      if conds.nil? || conds == {}
        self
      else
      end
    end

    def to_a
      filtered(collection, conditions)
    end

    private

    def filtered(records, conds)
      records.select do |record|
        conds.all? do |name, match|
          value = record.public_send(name)
          match.instance_of?(Array) ? match.include?(value) : value.eql?(match)
        end
      end
    end
  end
end
