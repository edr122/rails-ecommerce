puts "Datos en entorno: #{Rails.env}"

# Limpia datos existentes
Purchase.delete_all
ProductCategory.delete_all
Product.delete_all
Category.delete_all
Customer.delete_all
AdminUser.delete_all

# Admins
admin1 = AdminUser.create!(email: "admin1@example.com", password: "password")
admin2 = AdminUser.create!(email: "admin2@example.com", password: "password")

# Customers
customers = [
  Customer.create!(name: "Alice Smith", email: "alice@example.com"),
  Customer.create!(name: "Bob Johnson", email: "bob@example.com"),
  Customer.create!(name: "Carol Davis", email: "carol@example.com"),
  Customer.create!(name: "David Lee", email: "david@example.com"),
  Customer.create!(name: "Eva Brown", email: "eva@example.com")
]

# Categories
categories = [
  Category.create!(name: "Category 1", description: "Electronics", admin_user: admin1),
  Category.create!(name: "Category 2", description: "Home Goods", admin_user: admin1),
  Category.create!(name: "Category 3", description: "Fashion", admin_user: admin1)
]

# Products
products = [
  Product.create!(name: "Sleek Copper Clock", description: "Elegant wall clock", price: 71.0, stock: 30, admin_user: admin1),
  Product.create!(name: "Fantastic Iron Gloves", description: "Durable iron gloves", price: 41.0, stock: 50, admin_user: admin2),
  Product.create!(name: "Heavy Duty Silk Coat", description: "Warm winter coat", price: 75.0, stock: 20, admin_user: admin2),
  Product.create!(name: "Modern Wooden Lamp", description: "Stylish bedside lamp", price: 52.0, stock: 40, admin_user: admin1),
  Product.create!(name: "Portable Leather Speaker", description: "Bluetooth speaker", price: 99.0, stock: 10, admin_user: admin1)
]

# Asociaciones producto-categoría
products[0].categories << [categories[0], categories[1]]
products[1].categories << [categories[0]]
products[2].categories << [categories[2]]
products[3].categories << [categories[1], categories[2]]
products[4].categories << [categories[0]]

# Crear 30 compras entre 2025-05-01 y 2025-05-30
30.times do |i|
  date = DateTime.new(2025, 5, 1) + i
  product = products[i % products.length]
  customer = customers[i % customers.length]
  quantity = (i % 3) + 1
  total = product.price * quantity

  Purchase.create!(
    product: product,
    customer: customer,
    quantity: quantity,
    total_amount: total,
    purchased_at: date.change({ hour: 10 + (i % 8) }) # Distribuir entre 10:00 y 17:00
  )
end

products.each_with_index do |product, index|
  next if index.odd? # Solo para algunos productos

  image_path = Rails.root.join("app/assets/images/sample_#{index % 3 + 1}.jpg")
  if File.exist?(image_path)
    product.images.attach(
      io: File.open(image_path),
      filename: "sample_#{index % 3 + 1}.jpg",
      content_type: "image/jpeg"
    )
  end
end

puts "Seeds completados con éxito."
