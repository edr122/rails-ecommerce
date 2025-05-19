class DailyPurchaseReportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    start_time = 1.day.ago.beginning_of_day
    end_time   = 1.day.ago.end_of_day


    purchases = Purchase.where(purchased_at: start_time..end_time)
                        .includes(:product)


    report_data = purchases.group_by(&:product).map do |product, items|
      {
        product_name: product.name,
        total_quantity: items.sum(&:quantity),
        total_amount: items.sum(&:total_amount).to_f
      }
    end

    AdminUser.find_each do |admin|
      PurchaseReportMailer.daily_report(admin, report_data, start_time.to_date).deliver_later
    end
  end
end
