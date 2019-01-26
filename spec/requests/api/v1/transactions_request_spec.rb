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
    27.times do
      sample = query_params.sample
      get "/api/v1/transactions/find?#{sample}"
      transaction = JSON.parse(response.body)
      expect(transaction["data"]["attributes"]["id"]).to eq(123)
    end
  end
  it 'can find multiple transactions by different attributes' do
    create(:transaction, id: 123, credit_card_number: 4242424242421234, result: "success")
    create(:transaction, id: 400, credit_card_number: 1111111111111111, result: "success")
    create(:transaction)

    get '/api/v1/transactions/find_all?result=success'

    matching_transactions = (JSON.parse(response.body))["data"]
    transaction_1_attributes = matching_transactions[0]["attributes"]
    transaction_2_attributes = matching_transactions[1]["attributes"]

    10.times do
      expect(matching_transactions.sample["attributes"]["result"]).to eq("success")
    end

    expect(transaction_1_attributes["id"]).to eq(123)
    expect(transaction_2_attributes["id"]).to eq(400)
  end
  it 'can find a random transaction' do
    create(:transaction)
    create(:transaction)
    create(:transaction)

    get '/api/v1/transactions/random'

    transaction = JSON.parse(response.body)
  end
end
