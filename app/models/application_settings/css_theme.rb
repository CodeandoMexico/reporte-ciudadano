class ApplicationSettings::CssTheme < ApplicationSetting
  DEFAULT_THEME_NAME = "theme_one"
  THEMES = %w{theme_one theme_two theme_three theme_four}

  attr_accessible :name
  validates :name, presence: true, inclusion: { in: THEMES }

  def self.get
    first || create!(name: DEFAULT_THEME_NAME)
  end

  def name() value end
  def name=(value) self.value = value end

end
