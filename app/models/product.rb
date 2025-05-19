class Product < ApplicationRecord
  belongs_to :admin_user
  has_many :purchases
  has_many :product_categories
  has_many :categories, through: :product_categories

  has_many_attached :images
  has_paper_trail

  validates :name, :price, :stock, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
