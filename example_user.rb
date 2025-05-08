class User
  attr_accessor :name, :email

  def initialize(attributes = {})
    @name = attributes[:name]
    @email = attributes[:email]
  end

  def formatted_email
    "#{@name} <#{@email}>"
  end

  def inspect
    "#<User name: #{@name.inspect}, email: #{@email.inspect}>"
  end
end
