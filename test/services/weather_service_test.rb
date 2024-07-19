require "test_helper"

class WeatherServiceTest < Minitest::Test
  def setup
    @city = "Lagos"
    @test_api_key = "1234567890"
    @service = WeatherService.new(@city)
  end

  def test_fetch_weather_successfully
    @service.stub :fetch_api_key, @test_api_key do
      coordinates_response = [
        { "lat" => 9.0820, "lon" => 8.6753, "country" => "NG" },
      ].to_json
      weather_response = {
        "hourly" => Array.new(6) { { "temp" => 15 } },
        "daily" => [{ "temp" => { "day" => 15 } }],
      }.to_json

      stub_request(:get, "http://api.openweathermap.org/geo/1.0/direct")
        .with(query: { q: @city, limit: 1, appid: @test_api_key })
        .to_return(status: 200, body: coordinates_response, headers: { "Content-Type" => "application/json" })

      stub_request(:get, "http://api.openweathermap.org/data/3.0/onecall")
        .with(query: { lat: 9.0820, lon: 8.6753, exclude: "minutely,alerts", units: "metric", appid: @test_api_key })
        .to_return(status: 200, body: weather_response, headers: { "Content-Type" => "application/json" })

      result = @service.fetch_weather

      assert_equal 15, result["hourly"].first["temp"]
      assert_equal 15, result["daily"].first["temp"]["day"]
      assert_equal "NG", result["country"]
    end
  end

  def test_returns_error_for_invalid_coordinate
    @service.stub :fetch_api_key, @test_api_key do
      stub_request(:get, "http://api.openweathermap.org/geo/1.0/direct")
        .with(query: { q: @city, limit: 1, appid: @test_api_key })
        .to_return(status: 200, body: [].to_json, headers: { "Content-Type" => "application/json" })

      result = @service.fetch_weather

      assert_equal :not_found, result["code"]
    end
  end
end
