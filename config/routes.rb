Rails.application.routes.draw do

  tables = [:merchants,
            :customers,
            :invoices,
            :invoice_items,
            :items,
            :transactions
          ]

  namespace :api do
    namespace :v1 do
      tables.each do |table|
        namespace table do
          get '/find', to: 'search#show'
          get '/find_all', to: 'search#index'
          get '/random', to: 'random#show'
          get '/most_revenue', to: 'most_revenue#index' if table == :merchants
        end
      end

      resources :customers, only: [:index, :show] do
        resources :invoices, only: [:index]
        resources :transactions, only: [:index]
      end
      resources :invoices, only: [:index, :show] do
        resources :transactions, only: [:index]
        resources :invoice_items, only: [:index]
        resources :items, only: [:index]
        resource :customer, only: [:show]
        resource :merchant, only: [:show]
      end
      resources :items, only: [:index, :show] do
        resources :invoice_items, only: [:index]
        resource :merchant, only: [:show]
      end
      resources :invoice_items, only: [:index, :show] do
        resource :invoice, only: [:show]
        resource :item, only: [:show]
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
        resources :invoices, only: [:index]
      end
      resources :transactions, only: [:index, :show] do
        resource :invoice, only: [:show]
      end
    end
  end
end
