Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      post 'login', to: 'auth#login'
      #stats
      get 'stats/most_purchased_products', to: 'stats#most_purchased_products'
      get "stats/top_earning_products", to: "stats#top_earning_products_by_category"
      get "stats/purchase_volume", to: "stats#volume_by_granularity"
      #purchases
      get 'purchases/filter', to: 'purchases#filtered'
    end
  end
end
