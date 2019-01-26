require 'rails_helper'

describe 'Merchants API' do
  before(:each) do
    @m_1 = create(:merchant)
    item_1 = create(:item, merchant: @m_1)
    item_2 = create(:item, merchant: @m_1)
    item_3 = create(:item, merchant: @m_1, description: "test")
    item_4 = create(:item, merchant: @m_1)
    c_1 = create(:customer)
    invoice_1 = create(:invoice, customer: c_1, merchant: @m_1)
    invoice_2 = create(:invoice, customer: c_1, merchant: @m_1, status: "burger")
    invoice_3 = create(:invoice, customer: c_1, merchant: @m_1)
  end

  it 'sends items specific to one merchant' do

    get "/api/v1/merchants/#{@m_1.id}/items"

    items = JSON.parse(response.body)
    expect(items["data"][2]["attributes"]["description"]).to eq("test")
  end
  it 'sends invoices specific to one merchant from their known orders' do

    get "/api/v1/merchants/#{@m_1.id}/invoices"

    invoices = JSON.parse(response.body)
    expect(invoices["data"][1]["attributes"]["status"]).to eq("burger")
  end
end
