class SwitchToHstoreForMetadata < ActiveRecord::Migration
  def change
    add_column :metadata, :camera, :hstore
    add_column :metadata, :creator, :hstore
    add_column :metadata, :image, :hstore
    add_column :metadata, :settings, :hstore
  end
end
