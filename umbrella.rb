require"open-uri"
require"json"
require"time"
require'ascii_charts'

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_key = ENV.fetch("GMAPS_KEY")

puts "Where are you?"
user_location = gets.chomp
puts "Checking the weather at #{user_location}....\n"

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

puts "Your coordinates are #{lat}, #{lng}.\n"

# export weather from private_weather
pirvate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{lat},#{lng}"

raw_weather = URI.open(pirvate_weather_url).read
parsed_weather = JSON.parse(raw_weather)
parsed_weather.keys
currently = parsed_weather.fetch("currently")

current_temperature = currently.fetch("temperature")
current_weather = currently.fetch("summary")

puts "It is currently #{current_temperature}°F."

hourly = parsed_weather.fetch("hourly",false)
hourly_summary = hourly.fetch("summary")
puts "Next hour: Weather is #{hourly_summary}"

hourly_data = hourly.fetch("data")
any_precipitation = false

charts_array = Array.new

13.times do |count|
  if count != 0
    precip_prob = hourly_data.at(count).fetch("precipProbability")
    if precip_prob > 0.1
      puts "In #{count} hours, there is a #{(precip_prob * 100).round(2)}% chance of precipitation."
      any_precipitation = true
    end
    charts_array.push([count,precip_prob*100])
  end
end

if any_precipitation
  puts "Hours from now vs Precipitation probability:"
  
  puts AsciiCharts::Cartesian.new(charts_array,  :bar => true, :hide_zero => true).draw

  puts "You might want to take an umbrella!"
else
  puts "You don't need an umbrella!"
end
