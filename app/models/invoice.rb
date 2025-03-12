class Invoice < ApplicationRecord
  belongs_to :merchant
  belongs_to :customer
  belongs_to :coupon, optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  def self.for_merchant(merchant_id)
    where(merchant_id: merchant_id)
  end

  def self.filter_by_status(status)
    where(status: status) if valid_status?(status)
  end

  def self.find_by_merchant(merchant_id, id)
    find_by(id: id, merchant_id: merchant_id)
  end

  def self.valid_status?(status)
    ["returned", "shipped", "packaged"].include?(status)
  end

  def self.apply_coupon(invoice_id, merchant_id, coupon_id)
    invoice = find_by_merchant(merchant_id, invoice_id)
    return { success: false, error: "Invoice not found" } if invoice.nil?

    coupon = Coupon.find_by(id: coupon_id, merchant_id: merchant_id)
    return { success: false, error: "Coupon not found or doesn't belong to this merchant" } if coupon.nil?

    active_coupons_count = Coupon.where(merchant_id: merchant_id, status: "active").count
    if active_coupons_count >= 5
      return { success: false, error: "Merchant already has 5 activated coupons" }
    end

    invoice.update(coupon: coupon)
    coupon.update(status: "active")
    
    { success: true, invoice: invoice }
  end
end