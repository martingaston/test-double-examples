class AuthenticationFake
  # this is a very small example, but notice that with our fake we
  # are slightly different from a stub - we are performing some basic
  # logic, rather than always returning the same response.
  def authenticate(username, _password)
    username == 'user'
  end
end

class Application
  attr_reader :users

  def initialize(authenticator)
    @authenticator = authenticator
    @users = 0
  end

  def login(username, password)
    @users += 1 if @authenticator.authenticate(username, password)
  end
end

RSpec.describe Application do
  context 'when successfully authenticating' do
    it 'logs in when user exists' do
      # Arrange
      authenticator = AuthenticationFake.new
      subject = Application.new(authenticator)
      valid_user = 'user'
      valid_pass = 'password'

      # Act
      subject.login(valid_user, valid_pass)

      # Assert
      expect(subject.users).to eq 1
    end
  end

  context 'when unsuccessfully authenticating' do
    it 'does not log in if user does not exist' do
      # Arrange
      authenticator = AuthenticationFake.new
      subject = Application.new(authenticator)
      invalid_user = 'invalid_user'
      password = 'password'

      # Act
      subject.login(invalid_user, password)

      # Assert
      expect(subject.users).to eq 0
    end
  end
end
