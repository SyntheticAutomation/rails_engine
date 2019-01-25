require 'rails_helper'

describe 'InvoiceItems API' do
  it 'sends a list of invoice_items' do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].count).to eq(3)
  end
  it 'can get one invoice_item by its id' do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq(id.to_s)
  end
  it 'can find an invoice_item by different attributes' do
    create(:invoice_item, quantity: 14)
    create(:invoice_item, unit_price: 40.00)

    get '/api/v1/invoice_items/find?quantity=14'
    invoice_item = JSON.parse(response.body)
    expect(invoice_item["data"]["attributes"]["quantity"]).to eq(14)

    get '/api/v1/invoice_items/find?unit_price=40'

    i_i = JSON.parse(response.body)
    expect(i_i["data"]["attributes"]["unit_price"]).to eq(40.00)
  end
  it 'can find multiple invoice_items by different attributes' do
    create(:invoice_item, quantity: 14, unit_price: 200.00)
    create(:invoice_item, quantity: 14, unit_price: 61.00)

    get '/api/v1/invoice_items/find_all?quantity=14'

    matching_invoice_items = (JSON.parse(response.body))["data"]
    invoice_item_1_attributes = matching_invoice_items[0]["attributes"]
    invoice_item_2_attributes = matching_invoice_items[1]["attributes"]

    10.times do
      expect(matching_invoice_items.sample["attributes"]["quantity"]).to eq(14)
    end

    expect(invoice_item_1_attributes["unit_price"]).to eq(200.00)
  end
  it 'can find a random invoice_items' do
    create(:invoice_item)
    create(:invoice_item)
    create(:invoice_item)

    get '/api/v1/invoice_items/random'

    invoice_item = JSON.parse(response.body)
  end
end
