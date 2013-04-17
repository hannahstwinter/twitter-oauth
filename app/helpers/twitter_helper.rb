helpers do 

def configure_user

  Twitter.configure do |config|
    config.consumer_key = ENV["TWITTER_KEY"]
    config.consumer_secret = ENV["TWITTER_SECRET"]
    config.oauth_token = session[:oauth_token]
    config.oauth_token_secret = session[:oauth_token_secret]
  end

end

end
