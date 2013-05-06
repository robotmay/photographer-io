class DropTsVectorTrigger < ActiveRecord::Migration
  def up
    execute "DROP TRIGGER metadata_vector_update ON metadata;"
  end

  def down
    execute <<-SQL
      CREATE TRIGGER metadata_vector_update BEFORE INSERT OR UPDATE ON metadata FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('search_vector', 'pg_catalog.english', 'title', 'description');
    SQL
  end
end
