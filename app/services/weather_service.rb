class WeatherService
  include HTTParty
  base_uri "api.openweathermap.org"

  def initialize(city)
    @city = city
  end

  def fetch_weather
    coordinates = get_coordinates
    return { "code" => "404" } unless coordinates

    lat = coordinates["lat"]
    lon = coordinates["lon"]
    country = coordinates["country"]
    weather_data = self.class.get("/data/3.0/onecall", query: { lat: lat, lon: lon, exclude: "minutely,alerts", units: "metric", appid: fetch_api_key }).parsed_response
    processed_weather_data = process_weather_data(weather_data, country)
    processed_weather_data
  end

  private

  def fetch_api_key
    ENV["OPENWEATHER_API_KEY"]
  end

  def get_coordinates
    response = self.class.get("/geo/1.0/direct", query: { q: @city, limit: 1, appid: fetch_api_key }).parsed_response
    response.first if response.any?
  end

  def process_weather_data(weather_data, country)
    weather_data["hourly"] = weather_data["hourly"].take(6) if weather_data["hourly"]
    weather_data["daily"] = weather_data["daily"].take(1) if weather_data["daily"]
    weather_data["country"] = country
    weather_data
  end
end
