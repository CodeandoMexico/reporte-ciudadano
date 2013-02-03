class Comment < ActiveRecord::Base
  attr_accessible :content, :report_id

  belongs_to :commentable, polymorphic: true
  belongs_to :report
end
