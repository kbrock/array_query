class Person < Struct.new(:first_name, :last_name, :city, :state, :age)
  def name
    "#{first_name} #{last_name}"
  end
end
