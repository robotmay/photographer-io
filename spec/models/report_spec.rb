require 'spec_helper'

describe Report do
  it { should belong_to(:reportable) }
  it { should belong_to(:user) }

  [:reportable_id, :reportable_type, :user_id, :reason].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
