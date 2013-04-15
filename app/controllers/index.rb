require 'twitter'
require 'debugger'

get '/' do
  erb :index
end

get '/:username' do
  user = Twitter.user(params[:username])
  @user = User.find_or_create_by_user_name(user_name: user.username, name: user.name)
  if @user.tweets.empty? || tweets_stale?(@user)
    @user.tweets.destroy_all
    tweets = Twitter.user_timeline(@user.user_name).first(10)
    tweets.each do |tweet|
      @user.tweets.create(text: tweet.text, tweeted_at: tweet.created_at)
    end
  end
  erb :index
end
