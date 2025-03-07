require 'rails_helper'

RSpec.describe Coupon, type: :model do

    before(:each) do
        Merchant.destroy_all
        @merchant1 = Merchant.create!(name: "Barbara")
        @merchant2 = Merchant.create!(name: "Mark")
        @merchant3 = Merchant.create!(name: "Jackson")
        @merchant4 = Merchant.create!(name: "Jason")
    end

    describe "relationships" do
        it { should belong_to :merchant }
    end