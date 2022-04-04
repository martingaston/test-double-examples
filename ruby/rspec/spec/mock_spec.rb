
class UserMock
  def initialize
    @create_called = false
    @create_arguments = []
  end

  def create(username, password)
    @create_called = true
    @create_arguments = [username, password]
  end

  # verify is what makes this test double a mock - it handles all the verifications itself
  # most test double libraries will do this for you automatically, but we're doing it
  # manually to avoid the inherent magic of our mocking libraries.
  def verify
    @create_called && @create_arguments == %w[username password]
  end
end

class Signup
  def initialize(create_user)
    @user = create_user
  end

  def register(username, password)
    @user.create(username, password)
  end
end

RSpec.describe Signup do
  context 'when successfully registering a user' do
    it 'will call #create on its user dependency with valid input' do
      # Arrange
      user_mock = UserMock.new
      subject = Signup.new(user_mock)
      valid_user = 'username'
      valid_pass = 'password'

      # Act
      subject.register(valid_user, valid_pass)

      # Assert
      expect(user_mock.verify).to be true
    end
  end
end
