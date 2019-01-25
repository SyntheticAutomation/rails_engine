require 'rails_helper'

describe 'Invoices API' do
  it 'sends a list of invoices' do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_successful
    invoices = JSON.parse(response.body)
    expect(invoices["data"].count).to eq(3)
  end
  it 'can get one invoice by its id' do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq(id.to_s)
  end
  it 'can find an invoice by attributes' do
    create(:invoice, id: 230)

    get '/api/v1/invoices/find?id=230'

    invoice = JSON.parse(response.body)
    expect(invoice["data"]["attributes"]["id"]).to eq(230)
  end
  it 'can find multiple invoices by different attributes' do
    create(:invoice, id: 29)
    create(:invoice, id: 346)

    get '/api/v1/invoices/find_all?status=shipped'

    matching_invoices = (JSON.parse(response.body))["data"]
    invoice_1_attributes = matching_invoices[0]["attributes"]
    invoice_2_attributes = matching_invoices[1]["attributes"]

    10.times do
      expect(matching_invoices.sample["attributes"]["status"]).to eq("shipped")
    end

    expect(invoice_1_attributes["id"]).to eq(29)
  end
  it 'can find a random invoice' do
    create(:invoice)
    create(:invoice)
    create(:invoice)

    get '/api/v1/invoices/random'

    invoice = JSON.parse(response.body)
  end
end
