class Reply < ActiveRecord::Base
  include Markdownable

  acts_as_paranoid

  belongs_to :user
  belongs_to :topic, counter_cache: true

  validates :user_id, presence: true
  validates :topic_id, presence: true
  validates :body, presence: true
  validates :floor, presence: true, uniqueness: { scope: :topic_id }

  before_validation :set_floor, on: :create
  after_create :update_topic_attributes_after_create

  private

  def set_floor
    self.floor = topic.replies_count + 1
  end

  def update_topic_attributes_after_create
    topic.update_attributes(
      last_replied_user_id: user.id,
      last_replied_user_name: user.name,
      last_replied_at: created_at,
      actived_at: created_at
    )
  end
end
