class AddEnableCommentThreadsByDefaultToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enable_comments_by_default, :boolean, default: false
  end
end
