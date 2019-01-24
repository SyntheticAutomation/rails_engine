require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :status }
  end

  describe 'Relationships' do
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to :customer }
    it { should belong_to :merchant }
  end

  describe 'class methods' do
  end

  describe 'instance methods' do
  end

end
