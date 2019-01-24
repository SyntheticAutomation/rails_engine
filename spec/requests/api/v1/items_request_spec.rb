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
    create(:item, id: 999, name: "Burger", description: "yummy", unit_price: 10)

    query_params = [ 'id=999',
               'name=Burger',
               'description=yummy',
               'unit_price=10'
             ]
    1000.times do
      sample = query_params.sample
      get "/api/v1/items/find?#{sample}"
      item = JSON.parse(response.body)
      expect(item["data"]["attributes"]["id"]).to eq(999)
    end
  end
end
