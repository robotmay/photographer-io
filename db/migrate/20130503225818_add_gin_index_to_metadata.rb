class AddGinIndexToMetadata < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX "metadata_gin_keywords"
      ON metadata
      USING GIN(keywords)
    SQL
  end

  def down
    execute "DROP INDEX metadata_gin_keywords"
  end
end
