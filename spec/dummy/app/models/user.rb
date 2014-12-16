require 'securerandom'

class User
  attr_accessor :alchemy_roles, :name

  def id
    SecureRandom.random_number(100)
  end
end
