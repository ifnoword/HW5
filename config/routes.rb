Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  # for search TMDb
  post 'movies/search_tmdb'
  
  # for add TMDb
  post 'movies/add_tmdb'
end
