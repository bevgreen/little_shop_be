require 'rails_helper'
require 'pry'

RSpec.describe "Merchant Invoice Update endpoint", type: :request do

    describe "Update invoice with coupon" do

        it "applies the coupon and activates it" do
            merchant1 = Merchant.create!(name: "Barbara")
            coupon1 = Coupon.create!(name: "Holiday Sale", code: "BEMERRY", value: 0.30, merchant_id: merchant1.id, status: 'inactive')
            customer = Customer.create!(first_name: "John J.", last_name: "Jingleheimerschmidt")
            invoice = Invoice.create!(merchant_id: merchant1.id, customer_id: customer.id, coupon_id: coupon1.id, status: "pending")
    
            patch "/api/v1/merchants/#{merchant1.id}/invoices/#{invoice.id}",
                params: { coupon_id: coupon1.id }

            expect(response).to have_http_status(:ok)
            json_response = JSON.parse(response.body, symbolize_names: true)

            expect(json_response[:data][:attributes][:coupon_id]).to eq(coupon1.id)
            expect(Coupon.find(coupon1.id).status).to eq("active")
        end 
    end

end