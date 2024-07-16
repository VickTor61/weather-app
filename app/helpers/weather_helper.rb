module WeatherHelper
  def date_time
    now = Time.now
    now.strftime("%H:%M・%A, %e %B %Y").gsub(/(\d+)\s(\w+)/, '\1 \2')
  end

  def current_year
    Time.now.year
  end

  def time_of_day
    @time_of_day ||= begin
        case Time.now.hour
        when 6..11 then "morning"
        when 12 then "noon"
        when 13..17 then "afternoon"
        when 18..23 then "evening"
        else "night"
        end
      end
  end

  def city_location(country)
    "#{country}, #{@city}"
  end

  DYNAMIC_BACKGROUND = {
    "clouds" => "#FFE772",
    "rain" => "#CADDFD",
    "default" => "#DEF0FE",
  }

  def dynamic_bg_class(weather)
    DYNAMIC_BACKGROUND[weather.downcase] || DYNAMIC_BACKGROUND["default"]
  end
end
