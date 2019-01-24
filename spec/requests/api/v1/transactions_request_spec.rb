require 'rails_helper'

describe 'Transactions API' do
  it 'sends a list of transactions' do
    create_list(:transaction, 5)

    get '/api/v1/transactions'

    expect(response).to be_successful
    transactions = JSON.parse(response.body)
    expect(transactions["data"].count).to eq(5)
  end
  it 'can get one transaction by its id' do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"
    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"]).to eq(id.to_s)
  end
  it 'can find a transaction by attributes' do
    create(:transaction,
          id: 123,
          credit_card_number: 4242424242421234,
          result: "success"
        )
        
    query_params = [ 'id=123',
               'credit_card_number=4242424242421234',
               'result=success'
             ]
    1000.times do
      sample = query_params.sample
      get "/api/v1/transactions/find?#{sample}"
      transaction = JSON.parse(response.body)
      expect(transaction["data"]["attributes"]["id"]).to eq(123)
    end
  end
end
