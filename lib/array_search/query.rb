module ArraySearch
  class Query
    attr_accessor :collection, :conditions

    def initialize(c, conds = nil)
      @collection = c
      @conditions = conds || {}
    end

    def where(conds = nil)
      if conds.nil? || conds.eql?({}) # .blank?
        self
      else
        # TODO: handle a key that is already in conditions
        self.class.new(collection, conds.merge(conditions))
      end
    end

    def to_a
      filtered(collection, conditions)
    end

    private

    def filtered(records, conds)
      return records if conds.eql?({})
      records.select do |record|
        conds.all? do |name, match|
          value = record.public_send(name)
          match.instance_of?(Array) ? match.include?(value) : value.eql?(match)
        end
      end
    end
  end
end
