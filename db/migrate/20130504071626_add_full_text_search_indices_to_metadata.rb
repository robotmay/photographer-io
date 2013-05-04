class AddFullTextSearchIndicesToMetadata < ActiveRecord::Migration
  def up
    add_column :metadata, :search_vector, :tsvector
    execute <<-EOS
      CREATE INDEX index_metadata_on_search_vector ON metadata USING gin(search_vector)
    EOS

    execute <<-EOS
      CREATE TRIGGER metadata_vector_update BEFORE INSERT OR UPDATE
      ON metadata
      FOR EACH ROW EXECUTE PROCEDURE
        tsvector_update_trigger(search_vector, 'pg_catalog.english', title, description);
    EOS
  end
end
