Searchify::Engine.routes.draw do
  match '/search/:collection/:search_strategy' => "searchify#search"
  match '/search/:collection' => "searchify#search"
end
