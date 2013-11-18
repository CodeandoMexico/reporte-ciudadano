class Comment < ActiveRecord::Base
  attr_accessible :content, :service_request_id, :image

  belongs_to :commentable, polymorphic: true
  belongs_to :service_request
  mount_uploader :image, ImageUploader

  validates :content, presence: true
end
