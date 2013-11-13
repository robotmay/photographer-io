require 'spec_helper'

describe Category do
  let(:category) { Category.new(name: "Superhero") }

  it { should have_many(:photographs) }
  it { should have_many(:collections).through(:photographs) }

  describe '#name' do
    it 'should return category name' do
      category.name.should == "Superhero"
    end
  end
end
