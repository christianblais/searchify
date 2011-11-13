Searchify::Engine.routes.draw do
  get "searchify/search"

  match '/search/:collection' => "searchify#search"
end
