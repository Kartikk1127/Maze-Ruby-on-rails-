class Comment < ApplicationRecord
  default_scope {order(created_at: :desc)}
  belongs_to :article
  belongs_to :user

  # include Visible

  validates :body, presence: true
end
