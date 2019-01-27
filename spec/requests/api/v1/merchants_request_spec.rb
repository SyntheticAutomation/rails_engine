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
    item_1 = create(:item, merchant: merchant_1, unit_price: 1.0)
    item_2 = create(:item, merchant: merchant_2, unit_price: 1.0)
    invoice_1 = create(:invoice, merchant: merchant_1)
    invoice_2 = create(:invoice, merchant: merchant_2)
    create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 100.00)
    create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 100.00)

    get '/api/v1/merchants/most_revenue?quantity=2'

    expect(response).to be_successful
    top_merchants_by_revenue = JSON.parse(response.body)
    expect(top_merchants_by_revenue["data"].count).to eq(2)
  end

  it 'can send top merchants by number of items sold' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1, unit_price: 1.0)
    item_2 = create(:item, merchant: merchant_2, unit_price: 1.0)
    invoice_1 = create(:invoice, merchant: merchant_1)
    invoice_2 = create(:invoice, merchant: merchant_2)
    create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 100.00)
    create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 1, unit_price: 100.00)

    get '/api/v1/merchants/most_items?quantity=2'

    expect(response).to be_successful
    top_merchants_by_items_sold = JSON.parse(response.body)
    expect(top_merchants_by_items_sold["data"].count).to eq(2)
  end

  it 'can send total revenue across all merchants by date' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)
    invoice_1 = create(:invoice, merchant: merchant_1, created_at: Date.today)
    invoice_2 = create(:invoice, merchant: merchant_2, created_at: Date.today)
    create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 20, unit_price: 10000)
    create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 9, unit_price: 10000)
    date = Date.today.strftime("%F")

    get "/api/v1/merchants/revenue?date=#{date}"

    expect(response).to be_successful
    total_revenue = (JSON.parse(response.body))["data"][0]["attributes"]["total_revenue"]
    expect(total_revenue).to eq(2900)
  end

  it 'can send total revenue for a single merchant' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)
    invoice_1 = create(:invoice, merchant: merchant_1)
    invoice_2 = create(:invoice, merchant: merchant_2)
    create(:invoice_item, invoice: invoice_1, item: item_1)
    create(:invoice_item, invoice: invoice_2, item: item_2)
    create(:transaction, invoice: invoice_1, result: "success")

    get "/api/v1/merchants/#{merchant_1.id}/revenue"
    expect(response).to be_successful
    total_revenue = JSON.parse(response.body)
  end

  it 'can send revenue for a single merchant on a given date' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)
    invoice_1 = create(:invoice, merchant: merchant_1, created_at: Date.today)
    invoice_2 = create(:invoice, merchant: merchant_2, created_at: Date.today)
    create(:invoice_item, invoice: invoice_1, item: item_1)
    create(:invoice_item, invoice: invoice_2, item: item_2)
    create(:transaction, invoice: invoice_1, result: "success")
    date = Date.today.strftime("%F")

    get "/api/v1/merchants/#{merchant_1.id}/revenue?date=#{date}"

    expect(response).to be_successful
    total_revenue = (JSON.parse(response.body))["data"][0]["attributes"]["total_revenue"]
  end

  it 'can send the favorite customer of a merchant' do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    item_1 = create(:item, merchant: merchant_1)
    invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1)
    invoice_2 = create(:invoice, customer: customer_1, merchant: merchant_1)
    invoice_3 = create(:invoice, customer: customer_2, merchant: merchant_1)
    create(:transaction, invoice: invoice_1, result: "failed")
    create(:transaction, invoice: invoice_2, result: "failed")
    create(:transaction, invoice: invoice_3, result: "success")

    get "/api/v1/merchants/#{merchant_1.id}/favorite_customer"

    expect(response).to be_successful
    customer = JSON.parse(response.body)["data"]

  end

  it 'can find multiple merchants by different attributes' do
    create(:merchant, name: "Snacks by Steve", id: 349)
    create(:merchant, name: "Snacks by Steve", id: 11)

    get '/api/v1/merchants/find_all?name=Snacks%20by%20Steve'

    matching_merchants = (JSON.parse(response.body))["data"]
    merchant_1_attributes = matching_merchants[0]["attributes"]
    merchant_2_attributes = matching_merchants[1]["attributes"]

    10.times do
      expect(matching_merchants.sample["attributes"]["name"]).to eq("Snacks by Steve")
    end

    expect(merchant_1_attributes["id"]).to eq(349)
  end

  it 'can find a random merchant' do
    create(:merchant)
    create(:merchant)
    create(:merchant)

    get '/api/v1/merchants/random'

    merchant = JSON.parse(response.body)
  end
end
