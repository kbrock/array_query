require "array_search/version"
require "array_search/query"

module ArraySearch
  def self.wrap(collection)
    Query.new(collection)
  end
end
