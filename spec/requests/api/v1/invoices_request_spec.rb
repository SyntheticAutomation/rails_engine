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
end
