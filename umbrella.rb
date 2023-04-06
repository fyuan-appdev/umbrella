require"open-uri"
require"json"

p "Where are you?"
# user_location = gets.chomp
user_location = "Chicago"
p "Checking the weather at #{user_location}...."

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=AIzaSyB92cYxPcYqgjwBJfWlwDQw_7yjuyU3tpA"

raw_response = URI.open(gmaps_url).read
parsed_resonse = JSON.parse(raw_response)
results_array = parsed_resonse.fetch("results")
first_result = results_array.at(0)
geo = first_result.fetch("geometry")
loc = geo.fetch("location")
lat = loc.fetch("lat")
lng = loc.fetch("lng")

