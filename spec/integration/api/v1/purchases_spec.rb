require 'swagger_helper'

RSpec.describe 'Filtered Purchases API', type: :request do
  path '/api/v1/purchases/filter' do
    get 'Retrieve filtered purchases' do
      tags 'Purchases'
      produces 'application/json'

      parameter name: :from_date, in: :query, type: :string, format: :date, required: false, description: 'Start date (YYYY-MM-DD)'
      parameter name: :to_date, in: :query, type: :string, format: :date, required: false, description: 'End date (YYYY-MM-DD)'
      parameter name: :category_id, in: :query, type: :integer, required: false
      parameter name: :customer_id, in: :query, type: :integer, required: false
      parameter name: :admin_id, in: :query, type: :integer, required: false
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number for pagination'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page'

      response '200', 'filtered purchases found' do
        let(:admin_user) { AdminUser.create(email: 'admin@example.com', password: 'password') }
        let(:Authorization) do
          token = JsonWebToken.encode(admin_user_id: admin_user.id)
          "Bearer #{token}"
        end

        let(:from_date) { '2025-05-01' }
        let(:to_date) { '2025-06-01' }
        let(:page) { 1 }
        let(:per_page) { 5 }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
