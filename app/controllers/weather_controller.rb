class WeatherController < ApplicationController
  before_action :validate_city_params, :validate_api_key, only: [:show]

  def index
  end

  def show
    weather_service = WeatherService.new(@city)
    @weather = weather_service.fetch_weather

    if @weather.nil? || @weather["code"] == :not_found
      flash[:notice] = "Weather for #{@city} not found."
      redirect_to root_path
    end
  end

  private

  def validate_city_params
    @city = params[:city]
    redirect_to root_path, notice: "Please enter a city name" if @city.blank?
  end

  def validate_api_key
    ENV.fetch("OPENWEATHER_API_KEY") do
      redirect_to root_path, notice: "Please provide a valid API key"
    end
  end
end
