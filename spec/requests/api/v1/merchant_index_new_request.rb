require "rails_helper"

RSpec.describe "Merchants endpoints", type: :request do

    describe "index method with coupon and invoice count" do

        it "returns merchants with correct coupon and invoice coupon counts" do

            @merchant1 = Merchant.create!(name: "Barbara")
            @merchant2 = Merchant.create!(name: "Mark")
            @merchant3 = Merchant.create!(name: "Jackson")
            @merchant4 = Merchant.create!(name: "Jason")

            @customer1 = Customer.create!(first_name: "John J.", last_name: "Jingleheimerschmidt")
            @customer2 = Customer.create!(first_name: "Timmy", last_name: "Turner")
            @customer3 = Customer.create!(first_name: "Spongebob", last_name: "Squarepants")

            @coupon1 = Coupon.create!(name: "10% Off", code: "BIGTEN", value: 0.10, status: "active", merchant_id: @merchant1.id)
            @coupon2 = Coupon.create!(name: "15% Off", code: "BIG15", value: 0.15, status: "inactive", merchant_id: @merchant1.id)
            @coupon3 = Coupon.create!(name: "20% Off", code: "BIGT20", value: 0.20, status: "active", merchant_id: @merchant2.id)
            @coupon4 = Coupon.create!(name: "25% Off", code: "BIG25", value: 0.25, status: "active", merchant_id: @merchant2.id)

            @invoice1 = Invoice.create!(customer_id: @customer1.id, merchant_id: @merchant1.id, status: "shipped")
            @invoice2 = Invoice.create!(customer_id: @customer1.id, merchant_id: @merchant1.id, status: "returned")
            @invoice3 = Invoice.create!(customer_id: @customer2.id, merchant_id: @merchant2.id, status: "shipped")
            @invoice4 = Invoice.create!(customer_id: @customer3.id, merchant_id: @merchant2.id, status: "shipped")

            @invoice1.update(coupon_id: @coupon1.id)  
            @invoice3.update(coupon_id: @coupon3.id) 
            #put these here since it messed up previous tests

            get "/api/v1/merchants"
            expect(response).to be_successful
            merchants = JSON.parse(response.body, symbolize_names: true)

            merchant1_data = nil
            merchant2_data = nil              
                    merchants[:data].each do |merchant|
                    
                        if merchant[:id].to_i == @merchant1.id.to_i
                            merchant1_data = merchant
                        elsif merchant[:id].to_i == @merchant2.id.to_i
                            merchant2_data = merchant
                        end
                    end
    
                    expect(merchant1_data).not_to be_nil
                    expect(merchant2_data).not_to be_nil
                
                    expect(merchant1_data[:coupons_count]).to eq(2)
                    expect(merchant2_data[:coupons_count]).to eq(2)
                
                    expect(merchant1_data[:invoice_coupon_count]).to eq(1)
                    expect(merchant2_data[:invoice_coupon_count]).to eq(1)
        end      
    end
end