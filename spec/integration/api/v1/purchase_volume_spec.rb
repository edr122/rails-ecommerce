require 'swagger_helper'

RSpec.describe 'Purchase Volume API', type: :request do
  path '/api/v1/stats/purchase_volume' do
    get 'Get purchase volume with granularity' do
      tags 'Statistics'
      produces 'application/json'
      parameter name: :from_date, in: :query, type: :string, format: :date, required: true
      parameter name: :to_date, in: :query, type: :string, format: :date, required: true
      parameter name: :granularity, in: :query, type: :string, enum: %w[hour day week year], required: true
      parameter name: :category_id, in: :query, type: :integer, required: false
      parameter name: :customer_id, in: :query, type: :integer, required: false
      parameter name: :admin_id, in: :query, type: :integer, required: false

      response '200', 'success' do
        let(:admin_user) { AdminUser.create(email: 'admin@example.com', password: 'password') }
        let(:Authorization) do
          token = JsonWebToken.encode(admin_user_id: admin_user.id)
          "Bearer #{token}"
        end

        let(:from_date) { '2025-05-01' }
        let(:to_date) { '2025-06-01' }
        let(:granularity) { 'day' }

        run_test!
      end

      response '400', 'bad request (missing or invalid params)' do
        let(:admin_user) { AdminUser.create(email: 'admin5@example.com', password: 'password') }
        let(:Authorization) do
          token = JsonWebToken.encode(admin_user_id: admin_user.id)
          "Bearer #{token}"
        end
        let(:from_date) { '' }
        let(:to_date) { '' }
        let(:granularity) { '' }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalidtoken' }
        let(:from_date) { '2025-05-01' }
        let(:to_date) { '2025-06-01' }
        let(:granularity) { 'day' }
        run_test!
      end
    end
  end
end
