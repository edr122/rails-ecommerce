module Api
  module V1
    class StatsController < ApplicationController
      before_action :authorize_request

      def most_purchased_products
        result = Category.includes(products: :purchases).map do |category|
          most_purchased = category.products
            .joins(:purchases)
            .group('products.id')
            .select('products.*, SUM(purchases.quantity) AS total_quantity')
            .order('total_quantity DESC')
            .first

          {
            category: category.name,
            product: most_purchased&.name,
            total_quantity: most_purchased&.total_quantity.to_i
          }
        end

        render json: result
      end

      def top_earning_products_by_category
        results = Purchase.joins(product: :categories)
            .select('categories.id AS category_id, categories.name AS category_name, products.name AS product_name, SUM(purchases.total_amount) AS total_amount')
            .group('categories.id, categories.name, products.id, products.name')
            .order('categories.id, total_amount DESC')

        grouped_results = results.group_by(&:category_id).map do |category_id, records|
            {
            category_id: category_id,
            category_name: records.first.category_name,
            products: records.first(3).map do |r|
                {
                product: r.product_name,
                total_amount: r.total_amount.to_s
                }
            end
            }
        end

        render json: grouped_results
      end

      def volume_by_granularity
        from_date = params[:from_date].presence
        to_date = params[:to_date].presence
        granularity = params[:granularity].presence

        unless from_date && to_date && granularity
          return render json: { error: "from_date, to_date, and granularity are required" }, status: :bad_request
        end

        begin
          from_date_parsed = DateTime.parse(from_date)
          to_date_parsed = DateTime.parse(to_date)
        rescue ArgumentError
          return render json: { error: "Invalid date format" }, status: :bad_request
        end

        if to_date_parsed < from_date_parsed
          return render json: { error: "to_date must be after from_date" }, status: :bad_request
        end

        if (to_date_parsed.to_date - from_date_parsed.to_date).to_i > 183
          return render json: { error: "Date range cannot exceed 6 months" }, status: :bad_request
        end

        allowed_granularities = %w[hour day week year]
        unless allowed_granularities.include?(granularity)
          return render json: { error: "granularity must be one of: #{allowed_granularities.join(', ')}" }, status: :bad_request
        end

        # Query base
        purchases = Purchase.where(purchased_at: from_date_parsed..to_date_parsed)

        if params[:category_id].present?
          purchases = purchases.joins(product: :categories)
                              .where(categories: { id: params[:category_id] })
        end

        if params[:customer_id].present?
          purchases = purchases.where(customer_id: params[:customer_id])
        end

        if params[:admin_id].present?
          purchases = purchases.joins(:product)
                              .where(products: { admin_user_id: params[:admin_id] })
        end

        case granularity
        when "hour"
          format = "%Y-%m-%d %H:00"
          group_by = "DATE_TRUNC('hour', purchased_at)"
        when "day"
          format = "%Y-%m-%d"
          group_by = "DATE_TRUNC('day', purchased_at)"
        when "week"
          format = "%Y-W%U"
          group_by = "DATE_TRUNC('week', purchased_at)"
        when "year"
          format = "%Y"
          group_by = "DATE_TRUNC('year', purchased_at)"
        end

        result = purchases.group(Arel.sql(group_by)).order(Arel.sql(group_by)).count
        formatted_result = result.transform_keys { |datetime| datetime.strftime(format) }

        render json: formatted_result
      end
    end
  end
end