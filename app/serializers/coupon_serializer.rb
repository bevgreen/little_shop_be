class CouponSerializer
    include JSONAPI::Serializer
    attributes :name, :code, :value, :merchant_id
end
