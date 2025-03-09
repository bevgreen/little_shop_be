class Api::V1::CouponsController < ApplicationController
    def index
        coupons = Coupon.all
    
        render json: CouponSerializer.new(coupons)
    end

    def show
        coupon = Coupon.find(params[:id])
        render json: CouponSerializer.new(coupon)
    end

    def create
        coupon = Coupon.create!(coupon_update_params) 
        render json: CouponSerializer.new(coupon)
    end


    private 
    def coupon_update_params
        params.require(:coupon).permit(:name, :code, :value, :merchant_id)
      end
end