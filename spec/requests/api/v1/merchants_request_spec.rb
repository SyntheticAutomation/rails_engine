require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants["data"].count).to eq(3)
  end
  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(id.to_s)
  end
  it 'can send top merchants by revenue' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1, unit_price: 1)
    item_2 = create(:item, merchant: merchant_2, unit_price: 1)
    invoice_1 = create(:invoice, merchant: merchant_1)
    invoice_2 = create(:invoice, merchant: merchant_2)
    create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 100)
    create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 100)

    get '/api/v1/merchants/most_revenue?quantity=2'

    expect(response).to be_successful
    top_merchants_by_revenue = JSON.parse(response.body)
    expect(top_merchants_by_revenue["data"].count).to eq(2)
  end
  it 'can find a merchant by attributes' do
    create(:merchant, name: "Lucas")
    create(:merchant, name: "Dr Strangelove")

    get '/api/v1/merchants/find?name=Lucas'
    merchant = JSON.parse(response.body)
    expect(merchant["data"]["attributes"]["name"]).to eq("Lucas")
  end
end
