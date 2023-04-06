require"open-uri"
require"json"
require"time"
require'ascii_charts'

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_key = ENV.fetch("GMAPS_KEY")

p "Where are you?"
# user_location = gets.chomp
user_location = "Seatle"
p "Checking the weather at #{user_location.capitalize}...."

# export lat and loc from gmap
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_response = URI.open(gmaps_url).read
parsed_repsonse = JSON.parse(raw_response)
results_array = parsed_repsonse.fetch("results")
first_result = results_array.at(0)
geo = first_result.fetch("geometry")
loc = geo.fetch("location")
lat = loc.fetch("lat")
lng = loc.fetch("lng")

p "Your coordinates are #{lat}, #{lng}."

# export weather from private_weather
pirvate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"

raw_weather = URI.open(pirvate_weather_url).read
parsed_weather = JSON.parse(raw_weather)
parsed_weather.keys
currently = parsed_weather.fetch("currently")

current_temperature = currently.fetch("temperature")
current_weather = currently.fetch("summary")

p "It is currently #{current_temperature}°F."

hourly = parsed_weather.fetch("hourly",false)
hourly_summary = hourly.fetch("summary")
p "Next hour: Weather is #{hourly_summary}"

hourly_data = hourly.fetch("data")
any_precipitation = false

charts_array = Array.new

13.times do |count|
  if count != 0
    precip_prob = hourly_data.at(count).fetch("precipProbability")
    if precip_prob > 0.1
      p "In #{count} hours, there is a #{precip_prob*100}% chance of precipitation."
      any_precipitation = true
      charts_array.push([count,precip_prob*100])
    end
  end
end

if any_precipitation
  p "Hours from now vs Precipitation probability"
  
  
  p charts_array

  p AsciiCharts::Cartesian.new(charts_array,  :bar => true, :hide_zero => true).draw

  p "You might want to take an umbrella!"
else
  p "You don't need an umbrella!"
end
