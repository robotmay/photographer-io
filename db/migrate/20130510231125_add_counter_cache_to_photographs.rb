class AddCounterCacheToPhotographs < ActiveRecord::Migration
  def change
    add_column :photographs, :recommendations_count, :integer
    add_column :photographs, :favourites_count, :integer
    Photograph.find_each do |photo|
      Photograph.reset_counters(photo.id, :recommendations)
      Photograph.reset_counters(photo.id, :favourites)
    end
  end
end
