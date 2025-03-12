class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :invoices
    validates :code, presence: true, uniqueness: { case_sensitive: false }

    def self.find_coupon(id)
        find(id)
    end

    def self.filtered(params)
        query = Coupon.all
        query = query.where(merchant_id: params[:merchant_id]) if params[:merchant_id].present?
        query = query.where(status: params[:status].strip) if params[:status].present?
        query
    end
    
    def can_be_activated?
        merchant.coupons.where(status: "active").count < 5
    end
    
    def can_be_deactivated?
        !invoices.where(status: "pending").exists?
    end
    
    def update_status(new_status)
        if new_status == "active" && !can_be_activated?
            return { success: false, error: "Merchant can only have a maximum of 5 active coupons." }
        end
    
        if new_status == "inactive" && !can_be_deactivated?
            return { success: false, error: "Cannot deactivate a coupon with pending invoices." }
        end
    
        if self.update(status: new_status)
            { success: true, coupon: self }
        else
            { success: false, error: errors.full_messages }
        end
    end
    
    def self.use_count(coupon_id)
        joins(:invoices).where(id: coupon_id).count
    end
end