class Api::V1::MerchantInvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])

    if params[:status].present?
      unless Invoice.valid_status?(params[:status])
        render json: ErrorSerializer.search_parameters_error("Only valid values for 'status' query are 'returned', 'shipped', or 'packaged'"), status: :unprocessable_entity
        return
      end
      invoices = Invoice.for_merchant(merchant.id).filter_by_status(params[:status])
    else
      invoices = Invoice.for_merchant(merchant.id)
    end

    render json: InvoiceSerializer.new(invoices)
  end

  def update
    result = Invoice.apply_coupon(params[:id], params[:merchant_id], params[:coupon_id])

    if result[:success]
      render json: InvoiceSerializer.new(result[:invoice]), status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
    
  end
end