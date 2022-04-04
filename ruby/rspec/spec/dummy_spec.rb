require 'stringio'

class InputDummy
end

class Display
  # we need input and output to satisfy the constructor
  def initialize(input, output)
    @input = input
    @output = output
  end

  # this method needs @input but does not use @output
  def retreive_message
    # aside:
    # out InputDummy doesn't actually have a read method, but Ruby is dynamically typed
    # so this only gets checked at runtime - and we never run it
    @message = @input.read
  end

  # this method needs @output but does not use @input
  def show_message
    @output.puts "message: #{@message}!"
  end
end

RSpec.describe Display do
  context 'show_message' do
    it 'prefixes each message with message' do
      # Arrange
      input = InputDummy.new # we are only testing #show_method, so we just need to satisfy the constructor
      output = StringIO.new # in a more complex system I would probably advocate wrapping this with the adapter pattern
      subject = Display.new(input, output)

      # aside:
      # technically we could also do Display.new(nil, output) because Ruby is a dynamic language
      # dummies tend to be mostly useful for stricter languages where that's not allowed

      # Act
      subject.show_message

      # Assert
      expect(output.string).to include('message: ')
    end
  end
end
