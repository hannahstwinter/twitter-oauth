require 'twitter'
require 'debugger'

get '/' do
  erb :index
end

get '/:username' do
  user = Twitter.user(params[:username])
  @user = User.find_or_create_by_user_name(user_name: user.username, name: user.name)

  if @user.need_refreshing?
    erb :index_with_loader
  else
    erb :index_tweets
  end

end

get '/:username/tweets' do  
  user = Twitter.user(params[:username])
  @user = User.find_or_create_by_user_name(user_name: user.user_name, name: user.name)
  @user.load_tweets!
  erb :tweets, :layout => false
end
