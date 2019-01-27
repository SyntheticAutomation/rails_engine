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
  it 'can find a random customer' do
    create(:customer)
    create(:customer)
    create(:customer)

    get '/api/v1/customers/random'

    customer = JSON.parse(response.body)
  end

  it 'can get the favorite_merchant of a customer' do
    c_1 = create(:customer)
    m_1 = create(:merchant, name: "Ditcher, Quick, & Hyde Divorce Law, LLC")
    m_2 = create(:merchant, name: "The Codfather Fish & Chips")
    m_3 = create(:merchant, name: "Sew What? Tailoring Inc")
    inv_1 = create(:invoice, customer: c_1, merchant: m_1)
    inv_2 = create(:invoice, customer: c_1, merchant: m_1)
    inv_3 = create(:invoice, customer: c_1, merchant: m_1)
    inv_4 = create(:invoice, customer: c_1, merchant: m_2)
    inv_5 = create(:invoice, customer: c_1, merchant: m_3)

    get "/api/v1/customers/#{c_1.id}/favorite_merchant"

    expect(response).to be_successful
    merchant = JSON.parse(response.body)

  end
end
