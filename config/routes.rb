Searchify::Engine.routes.draw do
  match '/search/:collection' => "searchify#search"
end
