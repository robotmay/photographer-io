require 'spec_helper'

describe Story do
  let(:story) { Story.make }
  subject { story }

  it { should belong_to(:user) }
  it { should belong_to(:subject) }

  describe "#text" do
    let(:story) { Story.make(key: key, values: values) }
    let(:key) { "wibble" }
    let(:values) { { 'name' => 'Higgins' } }

    it "calls I18n.t" do
      I18n.should_receive(:t).with("wibble", { name: "Higgins" })
      story.text
    end
  end
end
