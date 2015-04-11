class User < ActiveRecord::Base
  DEFAULT_AVATAR = '/images/avatar.png'

  include TopicReadable

  attr_accessor :login

  devise :database_authenticatable,
         :registerable,
         :omniauthable,
         :validatable,
         :recoverable,
         :confirmable,
         :trackable,
         :rememberable,
         authentication_keys: [:login],
         omniauth_providers: [:github, :twitter]

  has_one :authorization
  has_many :topics
  has_many :replies
  has_many :favorites
  has_many :mentions
  has_many :notifications, class_name: 'Notification::Base'

  validates :name,
    uniqueness: { case_sensitive: false },
    length: { in: 3..20 },
    format: { with: /\A\w+\Z/ }

  before_save :set_default_avatar, unless: :has_avatar?
  after_update :set_topics_and_replies_user_avatar, if: :avatar_changed?

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup

    login = conditions.delete(:login)

    where(conditions).
      where('lower(name) = :value OR lower(email) = :value',
            { value: login.downcase }).
      first
  end

  def has_unread_notifications?
    unread_notifications_count > 0
  end

  def has_avatar?
    avatar.present?
  end

  def password_required?
    authorization.blank? && super
  end

  def email_required?
    authorization.blank? && super
  end

  private

  def set_default_avatar
    self.avatar = DEFAULT_AVATAR if avatar.blank?
  end

  def set_topics_and_replies_user_avatar
    topics.update_all(user_avatar: avatar)
    replies.update_all(user_avatar: avatar)
  end
end
