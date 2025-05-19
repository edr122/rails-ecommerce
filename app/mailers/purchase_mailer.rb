class PurchaseMailer < ApplicationMailer
    def first_purchase_notification(creator, purchase, others)
    @creator = creator
    @purchase = Purchase.includes(:product, :customer).find(purchase.id)
    return if @purchase.nil?
    
    @product = @purchase.product
    @customer = @purchase.customer
    @others = others

    mail(
        to: @creator.email,
        cc: @others.map(&:email),
        subject: "Primera compra del producto #{@product.name}"
    )
    end
end
