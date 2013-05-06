class AddIndicesToMetadataHstores < ActiveRecord::Migration
  def up
    execute "CREATE INDEX metadata_image_gin ON metadata USING gin(image)"
  end

  def down
    execute "DROP INDEX metadata_image_gin"
  end
end
