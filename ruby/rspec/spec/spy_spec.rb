class APIClientSpy
  attr_reader :fetch_weather_was_called,
              :fetch_weather_location

  def initialize
    @fetch_weather_was_called = false
    @fetch_weather_location = nil
  end

  def fetch_weather(location)
    @fetch_weather_was_called = true
    @fetch_weather_location = location

    # notice that we _are_ returning a stubbed response
    {
      degrees: 6,
      scale: 'celsius'
    }
  end
end

def MonitoringSpy
  attr_reader :weather_request_was_called,
              :weather_request_location
  
  def initialize
    @weather_request_was_called = false,
    @weather_request_location = nil
  end

  def weather_request(location)
    @weather_request_was_called = true
    @weather_request_location = location

    # in the production class this would then post off logs and metrics to our
    # monitoring service

    # notice we are _not_ returning a value
  end
end

class Forecast
  ForecastResponse = Struct.new(:degrees, :scale)

  def initialize(client, monitoring)
    @client = client
    @monitoring = monitoring
  end

  def for(location)
    @monitoring.weather_request(location)
    response = @client.fetch_weather(location)

    ForecastResponse.new(response[:degrees], response[:scale]).freeze
  end
end

RSpec.describe Forecast do
  it 'fetches weather for a location' do
    # Arrange
    api_client_spy = APIClientSpy.new # we keep a reference to our api_client_spy
    forecast = Forecast.new(api_client_spy)

    # Act
    result = forecast.for('London, UK')

    # Assert

    expect(result.degrees).to eq(6)
    expect(result.scale).to eq 'celsius'

    # we can now ask our api_client_spy if the expected behaviour was invoked
    expect(api_client_spy.fetch_weather_was_called).to be true
    expect(api_client_spy.fetch_weather_location).to eq 'London, UK'

    # aside:
    # this is somewhat opinionated, but even with outside-in/double heavy tests
    # I like to prefer methods that return values, and asserting on those returned
    # values, rather than testing that certain methods and such were actually called.

    # this is a testing smell, because we are both testing state - degrees is 6, scale
    # is celsuis **and** behaviour - we called the method, with these arguments. I would
    # argue that here we want our test to fail when the state of our return values change
    
    # I find spies are mostly useful in my workflow when a method does _not_ have
    # a return value, such as logging or metrics or stdout or something. So with a
    # spy we can assert that these types of methods are called with the desired
    # behaviour. so what might that look like?

    expect(monitoring_spy.weather_request_was_called).to be true
    expect(monitoring_spy.weather_request_location).to eq 'London, UK'

    # wait, that's the exact same test! this is true, but notice how it's more valuable
    # behaviour to assert for (in my opinion) _because_ our monitoring class does not
    # return a value. here, we want our test to fail when our API contract changes.
  end
end
