require 'rails_helper'
require 'pry'

RSpec.describe "Coupons endpoints", type: :request do


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
    end


    describe "#index" do
        it 'can retrieve all coupons' do
            get '/api/v1/coupons'

            expect(response).to be_successful
            coupons = JSON.parse(response.body, symbolize_names: true)
            expect(coupons[:data].count).to eq(4)
            expect(coupons[:data][0][:id]).to eq("#{@coupon1.id}")
            expect(coupons[:data][0][:type]).to eq("coupon")
            expect(coupons[:data][0][:attributes]).to be_a(Hash)
            expect(coupons[:data][0][:attributes][:name]).to eq("Holiday Sale")
            expect(coupons[:data][0][:attributes][:code]).to eq("BEMERRY")
            expect(coupons[:data][0][:attributes][:value]).to eq("0.3")
        end
    
        
    end










end