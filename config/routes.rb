Rails.application.routes.draw do

  tables = [:merchants,
            :customers,
            :invoices,
            :items,
            :invoice_items,
            :transactions
          ]

  namespace :api do
    namespace :v1 do
      tables.each do |table|
        namespace table do
          get '/find', to: 'search#show'
          get '/most_revenue', to: 'most_revenue#index' if table == :merchants
        end
      end
      resources :customers, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :merchants, only: [:index, :show]
      resources :transactions, only: [:index, :show]
    end
  end
end
