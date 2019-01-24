require 'rails_helper'

describe 'Transactions API' do
  it 'sends a list of transactions' do
    create_list(:transaction, 5)

    get '/api/v1/transactions'

    expect(response).to be_successful
    transactions = JSON.parse(response.body)
    expect(transactions.count).to eq(5)
  end
  it 'can get one transaction by its id' do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["id"]).to eq(id)
  end
end
