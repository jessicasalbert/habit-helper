require 'net/http'
require 'open-uri'
require 'json'

class Strava

    def direct_user
        puts "Please open the following link in your browser and authorize Strava"
        sleep(1)
        puts "Your authorization code will be found in the url after 'code='"
        sleep(1)
        puts "https://www.strava.com/oauth/authorize?client_id=53350&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=activity:read_all"
        sleep(1)
        puts "\nPlease enter the code from the authorization URL"
        @code = gets.chomp
    end

    def authenticate 
        activities_url = "https://www.strava.com/api/v3/athlete/activities?access_token="
        post_url = "https://www.strava.com/oauth/token?client_id=53350&client_secret=" + STRAVA_CLIENT_SECRET + "&code=" + @code + "&grant_type=authorization_code"
        uri = URI.parse(post_url)
        response = Net::HTTP.post_form(uri, {"q" => "My query", "per_page" => "50"})
        access_token_new = JSON.parse(response.body)['access_token']
        final_url = activities_url + access_token_new
        uri2 = URI(final_url)
        response = Net::HTTP.get(uri2)
        JSON.parse(response)
    end

    def display_activities
        self.authenticate.each do |run|
            puts "#{run["type"]} - #{(run["distance"]/1609.34).round(1)} miles - #{run["moving_time"]/60} minutes - #{run["name"]} "
        end
    end


end