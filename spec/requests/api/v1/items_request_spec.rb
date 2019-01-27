require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body)
    expect(items["data"].count).to eq(3)
  end
  it 'can get one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(id.to_s)
  end
  it 'can find an item by attributes' do
    create(:item, id: 999, name: "Burger", description: "yummy", unit_price: 10.00)

    query_params = [ 'id=999',
               'name=Burger',
               'description=yummy',
               'unit_price=10'
             ]
    100.times do
      sample = query_params.sample
      get "/api/v1/items/find?#{sample}"
      item = JSON.parse(response.body)
      expect(item["data"]["attributes"]["id"]).to eq(999)
    end
  end
  it 'can find multiple items by different attributes' do
    create(:item, id: 999, name: "Burger", description: "yummy", unit_price: 60.00)
    create(:item, id: 23, name: "iPhone", description: "facilitates tendonitis", unit_price: 60.00)

    get '/api/v1/items/find_all?unit_price=60'

    matching_items = (JSON.parse(response.body))["data"]
    item_1_attributes = matching_items[0]["attributes"]
    item_2_attributes = matching_items[1]["attributes"]

    10.times do
      expect(matching_items.sample["attributes"]["unit_price"]).to eq(60.00)
    end

    expect(item_1_attributes["name"]).to eq("Burger")
    expect(item_1_attributes["description"]).to eq("yummy")
    expect(item_2_attributes["id"]).to eq(23)
  end
  it 'can find a random item' do
    create(:item)
    create(:item)
    create(:item)

    get '/api/v1/items/random'

    item = JSON.parse(response.body)
  end
  describe 'BI Requests' do
    before(:each) do
      @i_1 = create(:item)
      @i_2 = create(:item)
      @i_3 = create(:item)
      @i_4 = create(:item)
      @invoice_1 = create(:invoice, created_at: Date.today)
      @invoice_2 = create(:invoice, created_at: Date.today)
      @invoice_3 = create(:invoice, created_at: Date.today)
      @invoice_4 = create(:invoice, created_at: Date.today)
      @invoice_item_1 = create(:invoice_item, item: @i_1, invoice: @invoice_1, unit_price: 1000, quantity: 1)
      @invoice_item_2 = create(:invoice_item, item: @i_2, invoice: @invoice_2, unit_price: 2000, quantity: 2)
      @invoice_item_3 = create(:invoice_item, item: @i_3, invoice: @invoice_3, unit_price: 3000, quantity: 3)
      @invoice_item_4 = create(:invoice_item, item: @i_4, invoice: @invoice_4, unit_price: 4000, quantity: 4)
    end

    it 'can send the top x items ranked by total revenue generated' do

      get "/api/v1/items/most_revenue?quantity=4"

      expect(response).to be_successful
      top_items_by_revenue = JSON.parse(response.body)["data"]
      expect(top_items_by_revenue[0]["attributes"]["revenue"]).to eq(160.00) #expect item 4 to be the top revenue generator and have the correct value
    end

    it 'can send the top x items ranked by number sold' do

      get "/api/v1/items/most_items?quantity=4"

      expect(response).to be_successful
      top_items_by_number_sold = JSON.parse(response.body)["data"]
      expect(top_items_by_number_sold[0]["attributes"]["quantity_sold"]).to eq(4)
    end

    it 'can send the best day by most sales for an item' do

      get "/api/v1/items/#{@i_1.id}/best_day"
    end
  end
end
