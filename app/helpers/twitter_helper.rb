def tweets_stale?(user)
  time = Time.now
  user.tweets.first.created_at < time - 900
end
