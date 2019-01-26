require 'rails_helper'

describe 'Transactions API' do
  before(:each) do
    m_1 = create(:merchant)
    c_1 = create(:customer)
    @item_1 = create(:item, merchant: m_1)
    @invoice_1 = create(:invoice, merchant: m_1, customer: c_1, status: "failed")
    @transaction_1 = create(:transaction, invoice: @invoice_1)
    @transaction_2 = create(:transaction, invoice: @invoice_1, result: "completely complete")
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 999)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 13)
  end

  it 'sends the invoice specific to one transaction' do
    get "/api/v1/transactions/#{@transaction_2.id}/invoice"
    invoice = JSON.parse(response.body)
    expect(invoice["data"]["attributes"]["status"]).to eq("failed")
  end
end
