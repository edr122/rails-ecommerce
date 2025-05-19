class Category < ApplicationRecord
  belongs_to :admin_user
  has_many :product_categories
  has_many :products, through: :product_categories

  has_paper_trail

  validates :name, presence: true
end
