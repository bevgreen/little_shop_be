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
            get '/api/v1/items'

            expect(response).to be_successful
            items = JSON.parse(response.body, symbolize_names: true)
        end
    
        
    end










end