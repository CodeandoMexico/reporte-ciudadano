class Comment < ActiveRecord::Base
  attr_accessible :content, :report_id, :image

  belongs_to :commentable, polymorphic: true
  belongs_to :report
  mount_uploader :image, ImageUploader
end
