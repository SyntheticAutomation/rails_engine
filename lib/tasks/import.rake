require 'csv'

namespace :import do
  desc "All"
  task all: [:customers, :merchants, :invoices, :items,  :transactions, :invoice_items]

  desc "customers"
  task customers: :environment do
    parse_csv("db/csv/customers.csv", Customer)
  end

  desc "invoice_items"
  task invoice_items: :environment do
    parse_csv("db/csv/invoice_items.csv", InvoiceItem)
  end

  desc "invoices"
  task invoices: :environment do
    parse_csv("db/csv/invoices.csv", Invoice)
  end

  desc "items"
  task items: :environment do
    parse_csv("db/csv/items.csv", Item)
  end

  desc "merchants"
  task merchants: :environment do
    parse_csv("db/csv/merchants.csv", Merchant)
  end

  desc "transactions"
  task transactions: :environment do
    parse_csv("db/csv/transactions.csv", Transaction)
  end
end

def parse_csv(path, model_name)
  csv_text = File.read(path)
  csv = CSV.parse(csv_text, headers: true)
  csv.each { |row| model_name.create!(row.to_h) }
end
