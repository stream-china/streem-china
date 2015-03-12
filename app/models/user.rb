class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:github]

  has_one :authorization
  has_many :topics
  has_many :replies
  has_many :favorites
  has_many :mentions
  has_many :notifications, class_name: 'Notification::Base'

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  include Redis::Objects
  hash_key :read_topics

  def has_unread_notifications?
    unread_notifications_count > 0
  end

  def update_read_topic(topic, ts=Time.now.to_i)
    read_topics[topic.id] = ts.to_i
  end

  def has_read_topic?(topic)
    read_topics[topic.id].to_i >= topic.actived_at.to_i
  end
end
