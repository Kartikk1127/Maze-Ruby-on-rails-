class Article < ApplicationRecord
  default_scope {order(created_at: :desc)}
  belongs_to :user
  has_many :likes
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  include Visible

  def latest_comment
    comments.order('created_at DESC').first
  end

  validates :title, presence: false
  validates :body, presence: true

end

