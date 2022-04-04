# this is our 'concrete' NumberGenerator we'll use in production
# note: we won't actually use this in this file, it's just an example
class NumberGenerator
  # returns a (psuedo) random number between 1 and 100
  def random_number
    Random.new.rand(100) + 1
  end
end

# this stub will be used in testing and will always return the same value
class NumberGeneratorStub
  # aside:
  # ⭐ stubs are my personal gold star of test doubles and often prove extremely
  # useful on all projects i've worked on

  def random_number
    1
  end
end

# aside:
# ☝️ notice how NumberGenerator and NumberGeneratorStub use the magic of duck typing;
# this is an _implicit_ interface - we can use any object as long as it receives and
# responds to #random_number.

# In compiled languages interfaces are often (always?) _explicit_, meaning they
# are declared and defined with keywords, such as `interface` and `implements` in Java.

class Game
  def initialize(number_generator)
    @target_number = number_generator.random_number
    @game_over = false
  end

  def guess(guess)
    @game_over = guess == @target_number
  end

  def over?
    @game_over
  end
end

RSpec.describe Game do
  context 'when the correct number is guessed' do
    it 'ends the game' do
      # Arrange
      number_generator = NumberGeneratorStub.new
      subject = Game.new(number_generator)
      correct_guess = 1

      # Act
      subject.guess(correct_guess)
      result = subject.over?

      # Assert
      expect(result).to be true
    end
  end

  context 'when an incorrect number is guessed' do
    it 'continues the game' do
      # Arrange
      number_generator = NumberGeneratorStub.new
      subject = Game.new(number_generator)

      # aside:
      # one risk of stubs is that it can be easy to end up with 'magic numbers' that hide test intent
      incorrect_guess = 42 

      # Act
      subject.guess(incorrect_guess)
      result = subject.over?

      # Assert
      expect(result).to be false
    end
  end
end
