class Person
  attr_accessor :name, :state
  def initialize(name = nil, state = nil)
    @name = name
    @state = state
  end
end
