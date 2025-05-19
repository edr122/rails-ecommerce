class PurchaseReportMailer < ApplicationMailer
  default from: "no-reply@ecommerce.com"

  def daily_report(admin_user, report_data, report_date)
    @admin = admin_user
    @report_data = report_data
    @report_date = report_date

    mail(
      to: @admin.email,
      subject: "Reporte diario de compras - #{@report_date.strftime('%d/%m/%Y')}"
    )
  end
end
