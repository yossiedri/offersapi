Rails.application.routes.draw do
  root 'offers#search' ,:as => "root"
  match 'search', :to => 'offers#search', :as => 'search', :via => [:get, :post]
end
