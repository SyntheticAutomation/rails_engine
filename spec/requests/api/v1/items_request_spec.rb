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
end
