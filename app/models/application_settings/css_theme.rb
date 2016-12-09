class ApplicationSettings::CssTheme < ApplicationSetting
  DEFAULT_THEME_NAME = "theme_one"
  THEMES = %w{theme_one theme_two theme_three theme_four theme_veda}

  #attr_accessible :name
  validates :name, presence: true, inclusion: { in: THEMES }

  def self.get
    if ENV["VEDA_ELECTORAL"] == "true" then
      unless self.where(value: "theme_veda").blank?
        self.where(value: "theme_veda").last
      else
        create!(name: "theme_veda")
      end

    else
      unless self.where(value: DEFAULT_THEME_NAME).blank?
        self.where(value: DEFAULT_THEME_NAME).last
      else
        create!(name: DEFAULT_THEME_NAME)
      end

    end
  end

  def name() value end
  def name=(value) self.value = value end

end
