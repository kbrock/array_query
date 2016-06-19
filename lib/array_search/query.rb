module ArraySearch
  class Query
    def initialize(collection)
      @collection = collection
    end

    def to_a
      @collection
    end
  end
end
