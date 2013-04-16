class User < ActiveRecord::Base
  has_many :tweets
  
  def need_refreshing?
    return true if self.loaded_at == nil 
    time = Time.now
    self.loaded_at < time - 900
  end

  def load_tweets!
    self.tweets.destroy_all
    self.loaded_at = Time.now
    self.save
    tweets = Twitter.user_timeline(self.user_name).first(10)
    tweets.each do |tweet|
      self.tweets.create(text: tweet.text, tweeted_at: tweet.created_at)
    end
  end

end
