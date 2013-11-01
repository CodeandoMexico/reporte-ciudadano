require 'spec_helper'

describe Logo do

  context 'attributes' do
    it { should respond_to :title }
    it { should respond_to :position }
    it { should respond_to :image }
  end

  context 'validations' do
    it { should validate_presence_of :image }
    it { should validate_presence_of :title }
  end

end
