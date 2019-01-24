require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful
    customers = JSON.parse(response.body)
    expect(customers["data"].count).to eq(3)
  end
  it 'can get a customer by id' do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(id.to_s)
  end
  it 'can find a customer by different attributes' do
    create(:customer, first_name: "Henry")
    create(:customer, first_name: "Maria")
    create(:customer, first_name: "Yuen", last_name: "Zhao")

    get '/api/v1/customers/find?last_name=Zhao'
    customer = JSON.parse(response.body)
    expect(customer["data"]["attributes"]["first_name"]).to eq("Yuen")

    get '/api/v1/customers/find?first_name=Maria'

    maria = JSON.parse(response.body)
    expect(maria["data"]["attributes"]["first_name"]).to eq("Maria")
  end
  it 'can find multiple customers by different attributes' do
    create(:customer, first_name: "L'Carpetron", last_name: "Dookmarriot")
    create(:customer, first_name: "Davoin", last_name: "Smith")
    create(:customer, first_name: "Javaris Jamar", last_name: "Javarison Lamar")
    create(:customer, first_name: "Davoin", last_name: "Shower Handle")

    get '/api/v1/customers/find_all?first_name=Davoin'

    matching_customers = (JSON.parse(response.body))["data"]
    customer_1_attributes = matching_customers[0]["attributes"]
    customer_2_attributes = matching_customers[1]["attributes"]

    10.times do
      expect(matching_customers.sample["attributes"]["first_name"]).to eq("Davoin")
    end

    expect(customer_1_attributes["last_name"]).to eq("Smith")
  end

end
