class ApplicationSettings::MapConstraints < ApplicationSetting

  DEFAULT_VALUE = {
    "zoom" => '8',
    "bounds" => [
      [25.52137536241251, -100.8489990234375],
      [25.91729099501301, -99.5306396484375]
    ]
  }

  attr_accessible :map_constraints
  validates :map_constraints, presence: true

  def self.get
    first || create!(map_constraints: DEFAULT_VALUE.to_json)
  end

  def map_constraints()
    self.value
  end

  def map_constraints=(value)
    self.value = value
  end

end
