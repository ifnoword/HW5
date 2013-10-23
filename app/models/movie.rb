class Movie < ActiveRecord::Base
#require 'themoviedb'

  def self.all_ratings
    %w(G PG PG-13 R)
  end
  
  def self.api_key
    'f4702b08c0ac6ea5b51425788bb26562'
  end

  def self.find_in_tmdb(keywords)
    result=[]
    Tmdb::Api.key(self.api_key)
    movies=Tmdb::Movie.find(keywords)
    if movies.size > 0
       movies.each do |movie|
         h=Hash.new
         h[:title]=movie.title
         h[:release_date]=movie.release_date,
         h[:rating]=Movie.all_ratings[Random.rand(Movie.all_ratings.size)]
         result << h
       end
    end
    return result
  end 
  
end
