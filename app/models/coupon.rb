class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :invoices

    def use_count
        invoices.count 
    end
end