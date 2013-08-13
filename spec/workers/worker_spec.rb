require 'spec_helper'

describe Worker do
  subject { Worker.new }
  let(:photograph) { Photograph.make }
  before { Photograph.stub(:find) { photograph } }
  before { Photograph.stub(:increment_score) { true } }

  it "runs any method" do
    photograph.should_receive(:increment_score)
    subject.perform('Photograph', 1, :increment_score, 1)
  end
end
