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
      namespace :merchants do
        get '/most_revenue', to: 'most_revenue#index'
        get '/most_items', to: 'most_items#index'
      end
      tables.each do |table|
        namespace table do
          get '/find', to: 'search#show'
          get '/find_all', to: 'search#index'
          get '/random', to: 'random#show'
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
        get '/customer', to: "invoices/customer#show"
        get '/merchant', to: "invoices/merchant#show"
      end
      resources :items, only: [:index, :show] do
        resources :invoice_items, only: [:index]
        get '/merchant', to: "items/merchant#show"
      end
      resources :invoice_items, only: [:index, :show] do
        get '/invoice', to: "invoice_items/invoice#show"
        get '/item', to: "invoice_items/item#show"
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
        resources :invoices, only: [:index]
      end
      resources :transactions, only: [:index, :show] do
        get '/invoice', to: 'transactions/invoice#show'
      end
    end
  end
end
