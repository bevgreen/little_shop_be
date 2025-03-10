class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :invoices

    def self.use_count(coupon_id)
        joins(:invoices).where(id: coupon_id).count
    end
end