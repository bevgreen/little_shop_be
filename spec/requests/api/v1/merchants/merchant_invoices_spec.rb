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

        it "returns an error and does not activate the coupon if merchant has 5 active already" do
            merchant1 = Merchant.create!(name: "Barbara")
            coupon1 = Coupon.create!(name: "Holiday Sale", code: "BEMERRY", value: 0.30, merchant_id: merchant1.id, status: 'active')
            coupon2 = Coupon.create!(name: "Birthday Sale", code: "HAPPYBDAY", value: 0.40, merchant_id: merchant1.id, status: 'active')
            coupon3 = Coupon.create!(name: "Buy one Get one 50% off", code: "BOGO50", value: 0.50, merchant_id: merchant1.id, status: 'active')
            coupon4 = Coupon.create!(name: "Early Bird Sale", code: "SPRING20", value: 0.20, merchant_id: merchant1.id, status: 'active')
            coupon5 = Coupon.create!(name: "Independence Day Sale", code: "FIREWORK40", value: 0.40, merchant_id: merchant1.id, status: 'active')
            coupon6 = Coupon.create!(name: "Daylight Savings Sale", code: "EARLYBIRD12", value: 0.40, merchant_id: merchant1.id, status: 'inactive')
            customer = Customer.create!(first_name: "John J.", last_name: "Jingleheimerschmidt")
            invoice = Invoice.create!(merchant_id: merchant1.id, customer_id: customer.id, coupon_id: nil, status: "pending")

            patch "/api/v1/merchants/#{merchant1.id}/invoices/#{invoice.id}",
                    params: { coupon_id: coupon6.id }
    
            expect(response).to have_http_status(:unprocessable_entity)
            json_response = JSON.parse(response.body, symbolize_names: true)
    
            expect(json_response[:error]).to eq("Merchant already has 5 activated coupons")
            expect(Coupon.find(coupon6.id).status).to eq("inactive") 
        end
    end

end