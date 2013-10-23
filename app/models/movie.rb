class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end
  
  def self.find_in_tmdb
    Tmdb::Api.key("")
  end 
  
end
