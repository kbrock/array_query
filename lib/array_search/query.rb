module ArraySearch
  class Query
    # mostly exposed for testing
    # private api at this time
    attr_accessor :collection, :conditions, :ordering

    def initialize(c, conds = nil, ordr = nil)
      @collection = c
      @conditions = conds || {}
      @ordering = ordr || []
    end

    def where(conds = nil)
      if conds.nil? || conds.eql?({}) # .blank?
        self
      else
        # TODO: handle a key that is already in conditions
        self.class.new(collection, conds.merge(conditions), ordering)
      end
    end

    def order(ordr)
      ordr ||= []
      ordr = [ordr] if !ordr.instance_of?(Array)
      ordr = ordering + ordr
      if ordr.eql?(ordering)
        self
      else
        self.class.new(collection, conditions, ordr)
      end
    end


    def except(*skips)
      self.class.new(collection,
                     skips.include?(:where) ? nil : conditions,
                     skips.include?(:order) ? nil : ordering)
    end

    def to_a
      ordered(filtered(collection, conditions), ordering)
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

    def ordered(records, ord)
      ord.eql?([]) ? records : records.sort_by { |r| ord.map { |col| r.public_send(col) } }
    end
  end
end
