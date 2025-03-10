class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :invoices
    validates :code, presence: true, uniqueness: { case_sensitive: false }

    def self.use_count(coupon_id)
        joins(:invoices).where(id: coupon_id).count
    end
end