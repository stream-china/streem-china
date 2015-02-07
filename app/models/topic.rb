class Topic < ActiveRecord::Base
  include Markdownable

  self.per_page = 20

  acts_as_paranoid

  belongs_to :user
  has_many :replies

  validates :user_id, presence: true
  validates :user_name, presence: true
  validates :user_avatar, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :actived_at, presence: true

  before_validation :set_attributes_beofre_validation_on_create, on: :create

  private

  def set_attributes_beofre_validation_on_create
    self.user_name = user.name
    self.user_avatar = user.avatar
    self.actived_at = Time.now
  end
end
