class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :customer

  validates :quantity, :total_amount, :purchased_at, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

  after_create :send_first_purchase_email

  private

  def send_first_purchase_email
    product.with_lock do
      if Purchase.where(product_id: product_id).count == 1
        creator = product.admin_user
        others  = AdminUser.where.not(id: creator.id).to_a # convertir a array

        PurchaseMailer
          .first_purchase_notification(creator, self, others)
          .deliver_later
      end
    end
  end
end
