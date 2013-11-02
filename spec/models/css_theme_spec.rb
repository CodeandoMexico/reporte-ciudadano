require 'spec_helper'

describe ApplicationSettings::CssTheme do

  context 'attributes' do
    it { should respond_to :name }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should ensure_inclusion_of(:name).in_array(%w{theme_one theme_two theme_three theme_four})}
  end

end
