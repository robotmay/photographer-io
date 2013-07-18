require 'spec_helper'

describe AdminUser do
  [:email, :password].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
