require "test_helper"

class WeatherHelperTest < ActionView::TestCase
  include WeatherHelper

  test "#formatted_date_time returns the correct format" do
    travel_to Time.new(2024, 7, 16, 14, 23, 0) do
      expected_format = "14:23・Tuesday, 16 July 2024"
      assert_equal expected_format, formatted_date_time
    end
  end

  test "#formatted_date_time refutes an incorrect format" do
    travel_to Time.new(2024, 7, 16, 14, 23, 0) do
      invalid_format = "14-23・Tuesday, 16th July 2024"
      refute_equal invalid_format, formatted_date_time
    end
  end

  test "#current_year returns the current year" do
    year = Time.now.year
    assert_equal year, current_year
  end

  test "#current_year refutes when the year is different from the current year" do
    year = 1.year.ago
    refute_equal year, current_year
  end

  test "#time_of_day should be morning when hour is between 6 to 11 am" do
    travel_to Time.new(2024, 7, 16, 07, 23, 0) do
      assert_equal "morning", time_of_day
    end
  end

  test "#time_of_day should be noon when hour is 12 noon" do
    travel_to Time.new(2024, 7, 16, 12, 23, 0) do
      assert_equal "noon", time_of_day
    end
  end

  test "#time_of_day should be afternoon when hour is between 1 to 5pm" do
    travel_to Time.new(2024, 7, 16, 14, 23, 0) do
      assert_equal "afternoon", time_of_day
    end
  end

  test "#time_of_day should be evening when hour is between 6 to 11pm" do
    travel_to Time.new(2024, 7, 16, 19, 23, 0) do
      assert_equal "evening", time_of_day
    end
  end

  test "#time_of_day should be night when hour is between 12 to 5am" do
    travel_to Time.new(2024, 7, 16, 05, 23, 0) do
      assert_equal "night", time_of_day
    end
  end

  test "#city_location should return passed country name and city" do
    country = "Nigeria"
    @city = "Lagos"
    expected_location = "Nigeria, #{@city}"
    assert_equal expected_location, city_location(country)
  end

  test "#country_name should refute if country name is different" do
    @city = "Lagos"
    expected_location = "Nigeria, #{@city}"
    refute_equal expected_location, city_location("dummyCountry")
  end

  test "dynamic_bg_class should return color #FFE772 when weather is cloudy" do
    weather = "clouds"
    assert_equal "#FFE772", dynamic_bg_class(weather)
  end

  test "dynamic_bg_class should return color #CADDFD when weather is cloudy" do
    weather = "rain"
    assert_equal "#CADDFD", dynamic_bg_class(weather)
  end

  test "dynamic_bg_class should return default color #DEF0FE when weather is neither rainy nor cloudy" do
    weather = "some_weather"
    assert_equal "#DEF0FE", dynamic_bg_class(weather)
  end
end
