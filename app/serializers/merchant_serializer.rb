class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  # :coupons_count, :invoice_coupon_count

  attribute :coupons_count do |merchant|
    merchant.try(:coupons)&.count || 0
  end

  attribute :invoice_coupon_count do |merchant|
    merchant.try(:invoices)&.where.not(coupon_id: nil)&.count || 0
  end
  
  attribute :item_count, if: Proc.new { |merchant, params|
    params && params[:count] == "true" }
end
