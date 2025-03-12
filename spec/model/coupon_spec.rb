require 'rails_helper'

RSpec.describe Coupon, type: :model do

    before(:each) do
        Merchant.destroy_all
        @merchant1 = Merchant.create!(name: "Barbara")
        @merchant2 = Merchant.create!(name: "Mark")
        @merchant3 = Merchant.create!(name: "Jackson")
        @merchant4 = Merchant.create!(name: "Jason")

        @coupon1 = Coupon.create!(name: "Holiday Sale", code: "BEMERRY", value: 0.30, merchant_id: @merchant1.id, status: 'inactive')
        @coupon2 = Coupon.create!(name: "Birthday Sale", code: "HAPPYBDAY", value: 0.40, merchant_id: @merchant1.id, status: 'active')
        @coupon3 = Coupon.create!(name: "Buy one Get one 50% off", code: "BOGO50", value: 0.50, merchant_id: @merchant2.id, status: 'inactive')
        @coupon4 = Coupon.create!(name: "Flash Sale", code: "FLASH50", value: 0.50, merchant_id: @merchant2.id, status: 'active')
    end

    describe "relationships" do
        it { should belong_to :merchant }
    end

    describe "Coupon model methods" do

        it "counts the number of times a coupon is used" do
            merchant = Merchant.create!(name: "Test Merchant")
            customer = Customer.create!(first_name: "John J.", last_name: "Jingleheimerschmidt")
            coupon1 = Coupon.create!(name: "Discount 10%", code: "SAVE10", value: 0.1, status: "active", merchant_id: merchant.id)
            coupon2 = Coupon.create!(name: "Discount 20%", code: "SAVE20", value: 0.2, status: "active", merchant_id: merchant.id)

            Invoice.create!(merchant_id: merchant.id, customer_id: customer.id, coupon: coupon1, status: "completed")
            Invoice.create!(merchant_id: merchant.id, customer_id: customer.id, coupon: coupon1, status: "pending")
            Invoice.create!(merchant_id: merchant.id, customer_id: customer.id, coupon: coupon2, status: "completed")

            expect(Coupon.use_count(coupon1.id)).to eq(2) 
            expect(Coupon.use_count(coupon2.id)).to eq(1) 
        end

        it "finds a coupon by id" do
            expect(Coupon.find_coupon(@coupon1.id)).to eq(@coupon1)
        end
        it "returns all coupons that belong to a specific merchant" do
            result = Coupon.filtered({ merchant_id: @merchant1.id })
            
            expect(result).to eq([@coupon1, @coupon2])
        end
        
        it "returns all coupons that match a specific status" do
            result = Coupon.filtered({ status: "active" })
        
            expect(result).to eq([@coupon2, @coupon4])
        end
        
        it "returns only coupons that match both merchant_id and status" do
            result = Coupon.filtered({ merchant_id: @merchant1.id, status: "inactive" })
        
            expect(result).to eq([@coupon1])
        end
        
        it "returns all coupons when no filter parameters are provided" do
            result = Coupon.filtered({})
        
            expect(result).to eq([@coupon1, @coupon2, @coupon3, @coupon4])
        end
        
        it "returns an empty array if no coupons match the filters" do
            result = Coupon.filtered({ merchant_id: 999 })
        
            expect(result).to eq([])
        end        
    end
end