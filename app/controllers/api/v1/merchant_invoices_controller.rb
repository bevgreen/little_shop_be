class Api::V1::MerchantInvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])

    if params[:status].present?
      if !["returned", "shipped", "packaged"].include?(params[:status])
        render json: ErrorSerializer.search_parameters_error("Only valid values for 'status' query are 'returned', 'shipped', or 'packaged'"), status: :unprocessable_entity
        return
      else
        invoices = merchant.invoices.filter_by_status(params[:status])
      end
    else
      invoices = merchant.invoices.all
    end

    render json: InvoiceSerializer.new(invoices)
  end

  def update 
    invoice = Invoice.find_by(id: params[:id], merchant_id: params[:merchant_id])

    if invoice.nil?
      return render json: { error: "Invoice not found" }, status: :not_found
    end

    if params[:coupon_id].present?
      coupon = Coupon.find_by(id: params[:coupon_id], merchant_id: params[:merchant_id])

      if coupon.nil?
        return render json: { error: "Coupon not found or doesn't belong to this merchant" }, status: :not_found
      end

      active_coupons_count = Coupon.where(merchant_id: params[:merchant_id], status: "active").count
      if active_coupons_count >= 5
        return render json: { error: "Merchant already has 5 activated coupons" }, status: :unprocessable_entity
      end

      invoice.update(coupon: coupon)
      coupon.update(status: "active")
    end

    render json: InvoiceSerializer.new(invoice), status: :ok
  end
end