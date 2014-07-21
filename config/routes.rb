Cins465P8::Application.routes.draw do

  root 'home#index'

  #home
  #get "home/index"
  get "search", to: 'home#search'
  get "search_results", to: 'home#search_results'

  #decks
  resources :decks do
    member do
      post "upload"
      get "download"
      get "test_practice_q"
      get "test_practice_a"
      get "test_regex_q"
      get "test_regex_a"
      get "test_regex_end"
    end
    #cards
    resources :cards do
      member do
        patch "move"
      end
    end
    #tags
    resources :tags
  end

  #users
  devise_for :users
  resources :users, :only => [:show]

end
