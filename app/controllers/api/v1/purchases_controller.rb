module Api
  module V1
    class Api::V1::PurchasesController < ApplicationController
        before_action :authorize_request

        def filtered
            purchases = Purchase

            # Filtrado por fechas con validación
            if params[:from_date].present? && params[:to_date].present?
                from = Date.parse(params[:from_date]) rescue nil
                to   = Date.parse(params[:to_date]) rescue nil
                if from && to
                purchases = purchases.where(purchased_at: from.beginning_of_day..to.end_of_day)
                end
            end

            if params[:category_id].present?
                purchases = purchases.joins(product: :categories).where(categories: { id: params[:category_id] })
            end

            if params[:customer_id].present?
                purchases = purchases.where(customer_id: params[:customer_id])
            end

            if params[:admin_id].present?
                purchases = purchases.joins(:product).where(products: { admin_user_id: params[:admin_id] })
            end

            purchases = purchases.includes(:product, :customer)

            page     = params[:page] || 1
            per_page = params[:per_page] || 10
            paginated = purchases.page(page).per(per_page)

            result = paginated.map do |purchase|
                {
                id: purchase.id,
                product: purchase.product.name,
                customer: purchase.customer.name,
                quantity: purchase.quantity,
                total_amount: purchase.total_amount,
                purchased_at: purchase.purchased_at
                }
            end

            render json: {
                current_page: paginated.current_page,
                total_pages: paginated.total_pages,
                total_count: paginated.total_count,
                purchases: result
            }
        end
    end
  end
end