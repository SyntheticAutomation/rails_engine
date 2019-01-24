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
    create(:invoice_item, unit_price: 4000)

    get '/api/v1/invoice_items/find?quantity=14'
    invoice_item = JSON.parse(response.body)
    expect(invoice_item["data"]["attributes"]["quantity"]).to eq(14)

    get '/api/v1/invoice_items/find?unit_price=4000'

    i_i = JSON.parse(response.body)
    expect(i_i["data"]["attributes"]["unit_price"]).to eq(4000)
  end
end
