class Comment < ApplicationRecord
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  
  belongs_to :micropost
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140 }
  attr_accessor :current_user

  after_create_commit do
    broadcast_append_to [micropost, :comments],
                        target: "#{dom_id(micropost)}_comments",
                        locals: { current_user: current_user }
    # broadcast_replace_to "micropost-#{micropost.id}",
    #                     target: "#{dom_id(micropost)}_comments_count",
    #                     html: "<h3 class='comments'>#{micropost.comments.count} Comments</h3>"
  end

  after_update_commit do
    broadcast_replace_to self, locals: { current_user: current_user }
  end

  after_destroy_commit do
    broadcast_remove_to self
    # broadcast_replace_to "micropost-#{micropost.id}",
    #                     target: "#{dom_id(micropost)}_comments_count",
    #                     html: "<h3 class='comments'>#{micropost.comments.count} Comments</h3>"
  end
end
