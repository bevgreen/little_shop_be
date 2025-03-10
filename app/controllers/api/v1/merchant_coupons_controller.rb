class Api::V1::MerchantCouponsController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
    def index
        merchant = Merchant.find(params[:merchant_id])
        coupons = merchant.coupons.all
    
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

    def update
        coupon = Coupon.find(params[:id])
        if coupon.status == "inactive" && coupon.merchant.coupons.where(status: "active").count >=5
            render json: ErrorSerializer.format(["Merchant can only have a maximum of 5 active coupons."]), status: :unprocessable_entity
            return #this stops the method from continuing
        end
        
        if coupon.update(status: "active")
            render json: CouponSerializer.new(coupon), status: :ok
        else
            render json: ErrorSerializer.format(coupon.errors.full_messages), status: :unprocessable_entity
        end
    end

    private 
    def coupon_update_params
        params.require(:coupon).permit(:name, :code, :value, :status, :merchant_id)
    end

    def handle_invalid_record(exception)
        render json: ErrorSerializer.format(exception.record.errors.full_messages), status: :unprocessable_entity
    end
end