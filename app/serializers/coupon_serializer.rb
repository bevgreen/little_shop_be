class CouponSerializer
    include JSONAPI::Serializer
    attributes :name, :code, :value, :status, :merchant_id
    
    attribute :use_count do |coupon|
        Coupon.use_count(coupon.id)
    end
end
