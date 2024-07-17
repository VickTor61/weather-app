class WeatherController < ApplicationController
  before_action :check_city_params, only: [:show]

  def index
  end

  def show
    weather_service = WeatherService.new(@city)
    @weather = weather_service.fetch_weather

    if @weather["code"] == "404"
      flash[:alert] = "Weather for #{@city} not found."
      redirect_to root_path
    end
  end

  private

  def check_city_params
    @city = params[:city]
    redirect_to root_path, alert: "Please enter a city name" if @city.blank?
  end
end
