class RemoveStoryTable < ActiveRecord::Migration
  def up
    drop_table :stories
  end
end
