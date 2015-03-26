class Logo < ActiveRecord::Base
  include ActAsSortable

  #attr_accessible :image, :position, :title, :image_cache

  validates :image, :title, presence: true

  mount_uploader :image, LogoUploader

end
