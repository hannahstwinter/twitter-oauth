class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.references :user
      t.datetime :tweeted_at
      t.timestamps
    end
  end
end
