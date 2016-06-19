module ArraySearch
  class Query
    def initialize(collection, conditions = nil)
      @collection = collection
      @conditions = conditions || {}
    end

    def where(conditions = nil)
      if conditions.nil? || conditions == {}
        self
      else
        self.class.new(@collection, conditions.merge(conditions))
      end
    end

    def to_a
      filtered(@collection, @conditions)
    end

    private

    def filtered(records, conditions)
      records.select do |record|
        conditions.all? do |name, good_value|
          value = record.public_send(name)
          if good_value.kind_of?(Array)
            good_value.include?(value)
          else
            value == good_value
          end
        end
      end
    end
  end
end
