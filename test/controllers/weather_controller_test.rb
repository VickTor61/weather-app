require "test_helper"

class WeatherControllerTest < ActionController::TestCase
  test "#index should render the index template and show the texts in it" do
    get :index
    assert_response :success
    assert_select "p", "See what the weather is like in your city today!"
  end

  test "#show should redirect to root path when city is blank" do
    get :show
    assert_redirected_to root_path
    assert_equal "Please enter a city name", flash[:notice]
  end

  test "#show should redirect to root path when no api key is provided with a notice" do
    ENV["OPENWEATHER_API_KEY"] = nil
    get :show, params: { city: "some" }

    assert_redirected_to root_path
    assert_equal "Please provide a valid API key", flash[:notice]
  end
  test "it should render the show page when city is found" do
    city = "London"
    mock_weather_data = {
      "current" => {
        "weather" => [{
          "main" => "clouds",
        }],
      },
      "hourly" => [{ "temp" => "20", "dt" => 1721318400, "weather" => [{
        "icon" => "02d",
      }] }],
      "daily" => [{ "temp" => { "day" => 20 } }],
      "country" => "GB",
    }

    mock_service = mock("weather_service")
    mock_service.expects(:fetch_weather).returns(mock_weather_data)
    WeatherService.expects(:new).with(city).returns(mock_service)

    get :show, params: { city: city }

    assert_response :success
    assert_select "h1", "#{mock_weather_data["country"]}, #{city}"
  end
  test "should redirect to root_path with alert if weather for city is not found" do
    city = "NonExistentCity"

    mock_service = mock("weather_service")
    mock_service.expects(:fetch_weather).returns(nil)
    WeatherService.expects(:new).with(city).returns(mock_service)

    get :show, params: { city: city }

    assert_redirected_to root_path
    assert_equal "Weather for #{city} not found.", flash[:notice]
  end
end
