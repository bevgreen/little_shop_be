require 'rails_helper'

describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
    it { should belong_to(:coupon).optional } 
  end
end