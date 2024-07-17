require "test_helper"
require "minitest/autorun"

class WeatherControllerTest < ActionController::TestCase
  test "#index should render the index template and show the texts in it" do
    get :index
    assert_response :success
    assert_select "p", "See what the weather is like in your city today!"
  end

  test "#show should redirect to root path when city is blank" do
    get :show
    assert_redirected_to root_path
    assert_equal "Please enter a city name", flash[:alert]
  end

  # <************  I HAVEN'T BEEN ABLE TO SUCCESSFULLY MOCK THIS ******************** *>
  test "should redirect to root_path with alert if weather for city is not found" do
    weather_service_mock = Minitest::Mock.new
    weather_service = WeatherService.new weather_service_mock

    @controller.stub(:weather_service, weather_service_mock) do
      get :show, params: { city: "NonExistentCity" }
      assert_redirected_to root_path
      assert_equal "Weather for NonExistentCity not found.", flash[:alert]
    end

    weather_service_mock.verify
  end
end
