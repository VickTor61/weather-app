require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "#index should render the index template and show the texts in it" do
    get root_path
    assert_response :success
    assert_select 'p', "See what the weather is like in your city today!"
  end

  test "#index should redirect to root path when city is blank" do
    get weather_path("")
    assert_redirected_to root_path
    assert_equal "Please enter a city name", flash[:alert]
  end
end
