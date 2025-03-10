require 'rails_helper'
require 'pry'

RSpec.describe "Merchant Coupons endpoints", type: :request do


    before(:each) do
        Merchant.destroy_all
        @merchant1 = Merchant.create!(name: "Barbara")
        @merchant2 = Merchant.create!(name: "Mark")
        @merchant3 = Merchant.create!(name: "Jackson")
        @merchant4 = Merchant.create!(name: "Jason")

        @coupon1 = Coupon.create!(name: "Holiday Sale", code: "BEMERRY", value: 0.30, merchant_id: @merchant1.id, status: 'inactive')
        @coupon2 = Coupon.create!(name: "Birthday Sale", code: "HAPPYBDAY", value: 0.40, merchant_id: @merchant2.id, status: 'inactive')
        @coupon3 = Coupon.create!(name: "Buy one Get one 50% off", code: "BOGO50", value: 0.50, merchant_id: @merchant3.id, status: 'inactive')
        @coupon4 = Coupon.create!(name: "Early Bird Sale", code: "SPRING20", value: 0.20, merchant_id: @merchant4.id, status: 'inactive')
        @coupon5 = Coupon.create!(name: "Independence Day Sale", code: "FIREWORK40", value: 0.40, merchant_id: @merchant1.id, status: 'inactive')
    end


    describe "#index tests" do
        it "happy path: returns all coupons of specified merchant (two examples)" do
            #Merchant with only one coupon
            get "/api/v1/merchants/#{@merchant2.id}/coupons"
            coupons_of_merchant = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(coupons_of_merchant[:data].length).to eq(1)
            expect(coupons_of_merchant[:data][0][:id].to_i).to eq(@coupon2.id)
            expect(coupons_of_merchant[:data][0][:attributes][:name]).to eq(@coupon2.name)

            #Merchant with two items (proper array)
            get "/api/v1/merchants/#{@merchant1.id}/coupons"
            coupons_of_merchant = JSON.parse(response.body, symbolize_names: true)

            expect(response).to be_successful
            expect(coupons_of_merchant[:data].length).to eq(2)
            expect(coupons_of_merchant[:data][0][:id].to_i).to eq(@coupon1.id)
            expect(coupons_of_merchant[:data][0][:attributes][:name]).to eq(@coupon1.name)
            expect(coupons_of_merchant[:data][1][:id].to_i).to eq(@coupon5.id)
            expect(coupons_of_merchant[:data][1][:attributes][:name]).to eq(@coupon5.name)
        end


        it "sad path: sends appropriate 400 level error when no merchant id found" do
            nonexistant_id = 100000
            updated_merchant_attributes = { name: "J-son" }
    
            headers = {"CONTENT_TYPE" => "application/json"}
            get "/api/v1/merchants/#{nonexistant_id}/coupons", headers: headers, params: JSON.generate(updated_merchant_attributes)
            
            error_message = JSON.parse(response.body, symbolize_names: true)
            updated_merchant = Merchant.find_by(id: nonexistant_id)
    
            expect(response).to_not be_successful
            expect(response.status).to eq(404)
            expect(error_message[:data][:message]).to eq("Merchant not found")
            expect(error_message[:data][:errors]).to eq(["Couldn't find Merchant with 'id'=#{nonexistant_id}"])
        end

    end

    describe "#show tests" do
        it "should return specific coupon based on id given" do
            coupon = @coupon2
            get "/api/v1/coupons/#{coupon.id}"

            expect(response).to be_successful
            json = JSON.parse(response.body, symbolize_names: true)
            expect(json[:data][:id].to_i).to eq(coupon.id)
            expect(json[:data][:type]).to eq("coupon")
            expect(json[:data][:attributes]).to be_a(Hash)
            expect(json[:data][:attributes][:name]).to eq(coupon.name)
        end

        # it "sad path: returns an error message when merchant does not exist" do
        #     get "/api/v1/coupons/1000" 

        #     expect(response).to have_http_status(:not_found)
        #     json = JSON.parse(response.body, symbolize_names: true)
        #     expect(json[:data][:message]).to eq("Coupon not found")
        #     expect(json[:data][:errors]).to be_a(Array)
        #     expect(json[:data][:errors][0]).to eq("Couldn't find Coupon with 'id'=1000")
        # end
    end

    describe "#create coupon" do
        it "creates a new coupon when given json data" do
            body = { coupon: {name: "New Coupon", code:"NEW2025", value: 0.25, merchant_id: @merchant2.id, status: "inactive" } }
            post "/api/v1/coupons", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)
            
            puts response.body
            expect(response).to have_http_status(:created)
            expect(json[:data][:attributes][:name]).to eq("New Coupon")
            expect(json[:data][:type]).to eq("coupon")
        end
    end





end