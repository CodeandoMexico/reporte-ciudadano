class Comment < ActiveRecord::Base
  #attr_accessible :content, :service_request_id, :image, :commentable

  belongs_to :commentable, polymorphic: true
  belongs_to :service_request
  mount_uploader :image, ImageUploader

  validates_presence_of :content, presence: true

  scope :default_order, ->{ order(created_at: :asc) }
  scope :approved, ->{ where(approved: true) }

  scope :pending, ->{ where(approved: false) }
end
