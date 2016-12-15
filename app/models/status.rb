class Status < ActiveRecord::Base
  enum status: [:inactive, :active]
  has_many :service_requests
  has_many :messages

  validates :name, presence: true

  before_create :set_default_if_is_the_first

  default_scope { active.order('created_at') }

  def to_s
    name
  end

  def cannot_be_deleted?
    self.is_default? || self.service_requests.any?
  end

  private

  def set_default_if_is_the_first
    # We assume the first created Status will be the default
    self.is_default = Status.first.nil?
    true
  end

  def self.close
    @@close ||= Status.find_by_name("Cerrado")
    @@close
  end

  def self.exclude_closed
    where("name != 'Cerrado'")
  end
end
