require 'rails_helper'
require 'pry'

RSpec.describe "Merchant Coupons endpoints", type: :request do


    before(:each) do
        Merchant.destroy_all
        @merchant1 = Merchant.create!(name: "Barbara")
        @merchant2 = Merchant.create!(name: "Mark")
        @merchant3 = Merchant.create!(name: "Jackson")
        @merchant4 = Merchant.create!(name: "Jason")

        @coupon1 = Coupon.create!(name: "Holiday Sale", code: "BEMERRY", value: 0.30, merchant: @merchant1)
        @coupon2 = Coupon.create!(name: "Birthday Sale", code: "HAPPYBDAY", value: 0.40, merchant: @merchant2)
        @coupon3 = Coupon.create!(name: "Buy one Get one 50% off", code: "BOGO50", value: 0.50, merchant: @merchant3)
        @coupon4 = Coupon.create!(name: "Early Bird Sale", code: "SPRING20", value: 0.20, merchant: @merchant4)
        @coupon5 = Coupon.create!(name: "Independence Day Sale", code: "FIREWORK40", value: 0.40, merchant: @merchant1)
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
    
        
    end










end