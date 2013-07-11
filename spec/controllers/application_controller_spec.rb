require "spec_helper"

describe ApplicationController do
  let(:instance) { ApplicationController.new }

  describe "#default_url_options" do
    let(:locale) { :pirate }
    before { I18n.stub(:locale) { locale } }

    it "sets the locale" do
      instance.default_url_options[:locale].should eq(locale)
    end
  end
end
