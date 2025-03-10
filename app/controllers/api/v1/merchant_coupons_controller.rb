class Api::V1::MerchantCouponsController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
    rescue_from ActiveRecord::RecordNotFound, with: :merchant_not_found
    # rescue_from ActiveRecord::RecordNotFound, with: :coupon_not_found
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
        render json: CouponSerializer.new(coupon), status: 201
    end

    def update
        coupon = Coupon.find(params[:id])
        new_status = params[:status]
        if new_status == "active"
            if coupon.merchant.coupons.where(status: "active").count >= 5
                render json: ErrorSerializer.format(["Merchant can only have a maximum of 5 active coupons."]), status: :unprocessable_entity
                return
            end
        end
        
        if new_status == "inactive"
            if coupon.invoices.where(status: "pending").exists?
                render json: ErrorSerializer.format(["Cannot deactivate a coupon with pending invoices."]), status: :unprocessable_entity
                return
            end
        end
        
        if coupon.update(status: new_status)
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

    def merchant_not_found(exception)
        render json: ErrorSerializer.handle_exception(exception, "Merchant not found"), status: :not_found
    end

    # def coupon_not_found(exception)
    #     render json: ErrorSerializer.handle_exception(exception, "Coupon not found"), status: :not_found
    # end
end