$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'array_search'

Dir["#{__dir__}/support/*"].each do |support_file|
  require support_file
end
