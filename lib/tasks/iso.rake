namespace :iso do
  namespace :rankings do
    task :adjust_scores => :environment do
      Photograph.adjust_scores
    end
  end
end
