class AddChannelKeyToUsers < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'
    add_column :users, :channel_key, :uuid, default: 'uuid_generate_v4()'
  end
end
