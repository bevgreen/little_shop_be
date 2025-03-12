require 'rails_helper'

describe Invoice, type: :model do

  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
    it { should belong_to(:coupon).optional } 
  end

  describe "class methods" do
    before(:each) do
      @merchant1 = Merchant.create!(name: "Merchant A")
      @merchant2 = Merchant.create!(name: "Merchant B")

      @customer = Customer.create!(first_name: "John", last_name: "Doe")

      @coupon = Coupon.create!(name: "10% Off", code: "SAVE10", value: 0.10, status: "inactive", merchant_id: @merchant1.id)

      @invoice1 = Invoice.create!(merchant: @merchant1, customer: @customer, status: "shipped")
      @invoice2 = Invoice.create!(merchant: @merchant1, customer: @customer, status: "packaged")
      @invoice3 = Invoice.create!(merchant: @merchant1, customer: @customer, status: "returned")
      @invoice4 = Invoice.create!(merchant: @merchant2, customer: @customer, status: "shipped")
    end

    describe ".for_merchant" do
      it "returns all invoices for a given merchant" do
        expect(Invoice.for_merchant(@merchant1.id)).to eq([@invoice1, @invoice2, @invoice3])
        expect(Invoice.for_merchant(@merchant2.id)).to eq([@invoice4])
      end
    end

    describe ".filter_by_status" do
      it "returns invoices matching a given status" do
        expect(Invoice.filter_by_status("shipped").where(merchant_id: [@merchant1.id, @merchant2.id])).to eq([@invoice1, @invoice4])
      end

      it "returns an empty array if no invoices match the status" do
        expect(Invoice.filter_by_status("pending")).to eq(nil)
      end
    end

    describe ".find_by_merchant" do
      it "returns the invoice if it belongs to the specified merchant" do
        expect(Invoice.find_by_merchant(@merchant1.id, @invoice1.id)).to eq(@invoice1)
      end

      it "returns nil if the invoice does not belong to the specified merchant" do
        expect(Invoice.find_by_merchant(@merchant2.id, @invoice1.id)).to eq(nil)
      end
    end

    describe ".valid_status?" do
      it "returns true for valid statuses" do
        expect(Invoice.valid_status?("shipped")).to eq(true)
        expect(Invoice.valid_status?("returned")).to eq(true)
        expect(Invoice.valid_status?("packaged")).to eq(true)
      end
    
      it "returns false for invalid statuses" do
        expect(Invoice.valid_status?("canceled")).to eq(false)
      end
    end

    describe ".apply_coupon" do
      before(:each) do
        @invoice = Invoice.create!(merchant: @merchant1, customer: @customer, status: "packaged")
      end

      it "applies a valid coupon to an invoice" do
        result = Invoice.apply_coupon(@invoice.id, @merchant1.id, @coupon.id)

        expect(result[:success]).to eq(true)
        expect(result[:invoice].coupon).to eq(@coupon)
        expect(@coupon.reload.status).to eq("active")
      end

      it "returns an error if the invoice does not exist" do
        result = Invoice.apply_coupon(999, @merchant1.id, @coupon.id)

        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq("Invoice not found")
      end

      it "returns an error if the coupon does not exist or does not belong to the merchant" do
        other_coupon = Coupon.create!(name: "15% Off", code: "SAVE15", value: 0.15, status: "inactive", merchant_id: @merchant2.id)
        result = Invoice.apply_coupon(@invoice.id, @merchant1.id, other_coupon.id)

        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq("Coupon not found or doesn't belong to this merchant")
      end

      it "returns an error if the merchant already has 5 active coupons" do
        Coupon.create!(name: "Discount 1", code: "EXTRA101", value: 0.10, status: "active", merchant_id: @merchant1.id)
        Coupon.create!(name: "Discount 2", code: "EXTRA102", value: 0.10, status: "active", merchant_id: @merchant1.id)
        Coupon.create!(name: "Discount 3", code: "EXTRA103", value: 0.10, status: "active", merchant_id: @merchant1.id)
        Coupon.create!(name: "Discount 4", code: "EXTRA104", value: 0.10, status: "active", merchant_id: @merchant1.id)
        Coupon.create!(name: "Discount 5", code: "EXTRA105", value: 0.10, status: "active", merchant_id: @merchant1.id)
      
        result = Invoice.apply_coupon(@invoice.id, @merchant1.id, @coupon.id)
      
        expect(result[:success]).to eq(false)
        expect(result[:error]).to eq("Merchant already has 5 activated coupons")
      end
    end
  end
end