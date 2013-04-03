class ApiKey < ActiveRecord::Base
  before_create :ensure_access_token

  belongs_to :admin
  validates :admin_id, presence: true

  def to_s
    self.access_token
  end

  def ensure_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

end
