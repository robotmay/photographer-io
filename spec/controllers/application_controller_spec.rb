require "spec_helper"

describe ApplicationController do
  let(:instance) { ApplicationController.new }

  describe "#fetch_categories" do
    before { Rails.cache.stub(:fetch) { raise NoMethodError } }
    before { Category.stub(:where) { [] } }

    it "cache failure shouldn't break the site" do
      instance.fetch_categories.should eq([])
    end
  end

  describe "#default_url_options" do
    let(:locale) { :pirate }
    before { I18n.stub(:locale) { locale } }

    it "sets the locale" do
      instance.default_url_options[:locale].should eq(locale)
    end
  end
end
