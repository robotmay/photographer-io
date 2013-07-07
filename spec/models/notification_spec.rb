require 'spec_helper'

describe Notification do
  it { should belong_to(:notifiable) }
end
