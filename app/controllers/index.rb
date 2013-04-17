enable :sessions
require 'twitter'
require 'debugger'

get '/' do
  erb :index
end

get '/oauth' do
  consumer = OAuth::Consumer.new(
    ENV["TWITTER_KEY"],
    ENV["TWITTER_SECRET"],
    :site => "https://api.twitter.com")

  oauth_callback = { :oauth_callback => "http://localhost:9393/auth" }
  session[:request_token] = consumer.get_request_token(oauth_callback)
  
  redirect session[:request_token].authorize_url
end

get '/auth' do
  
  oauth_verifier = { :oauth_verifier => params[:oauth_verifier] }
  access_token = session[:request_token].get_access_token(oauth_verifier)
  
  session[:request_token] = nil

  session[:oauth_token] = access_token.token

  session[:oauth_token_secret] = access_token.secret

  @client = Twitter::Client.new(
    :consumer_key => ENV["TWITTER_KEY"],
    :consumer_secret => ENV["TWITTER_SECRET"],
    :oauth_token => session[:oauth_token],
    :oauth_token_secret => session[:oauth_token_secret]
  )

  configure_user

  @user = @client.user
  
  username = @user.username

  redirect "/#{username}"

end

post '/:username/tweet' do
  configure_user
  # user = Twitter.user(params[:username]) user is hardcoded
  Twitter.update(params[:tweet])
  return "tweet tweeted!"
end

get '/:username' do

  configure_user

  user = Twitter.user(params[:username])
  @user = User.find_or_create_by_user_name(user_name: user.username, name: user.name)

  if @user.need_refreshing?
    erb :index_with_loader
  else
    erb :index_tweets
  end

end

get '/:username/tweets' do  
  configure_user

  user = Twitter.user(params[:username])
  @user = User.find_or_create_by_user_name(user_name: user.user_name, name: user.name)
  @user.load_tweets!
  erb :tweets, :layout => false
end
