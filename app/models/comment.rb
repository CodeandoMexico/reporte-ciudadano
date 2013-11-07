class Comment < ActiveRecord::Base
  attr_accessible :content, :report_id, :image

  belongs_to :commentable, polymorphic: true
  belongs_to :service_request
  mount_uploader :image, ImageUploader

  validates :content, presence: true
end
