class Api::V1::MerchantCouponsController < ApplicationController

    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
    rescue_from ActiveRecord::RecordNotFound, with: :merchant_not_found
    rescue_from ActiveRecord::RecordNotUnique, with: :handle_record_not_unique

    def index
        coupons = Coupon.filtered(params)  
        render json: CouponSerializer.new(coupons)
    end

    def show
        coupon = Coupon.find_coupon(params[:id])
        render json: CouponSerializer.new(coupon)
    end

    def create
        coupon = Coupon.new(coupon_update_params)

        if coupon.save
            render json: CouponSerializer.new(coupon), status: 200
        else
            render json: ErrorSerializer.format(coupon.errors.full_messages), status: :unprocessable_entity
        end
    end

    def update
        coupon = Coupon.find_coupon(params[:id])
        result = coupon.update_status(params[:status]) 

        if result[:success]
            render json: CouponSerializer.new(result[:coupon]), status: :ok
        else
            render json: ErrorSerializer.format([result[:error]]), status: :unprocessable_entity
        end
    end

    private 
    def coupon_update_params
        params.require(:coupon).permit(:name, :code, :value, :status, :merchant_id)
    end

    def handle_invalid_record(exception)
        render json: ErrorSerializer.format(exception.record.errors.full_messages), status: :unprocessable_entity
    end

    def merchant_not_found(exception)
        render json: ErrorSerializer.handle_exception(exception, "Merchant not found"), status: :not_found
    end

    def handle_record_not_unique(exception)
        render json: ErrorSerializer.format("Code has already been taken"), status: :unprocessable_entity
    end
end