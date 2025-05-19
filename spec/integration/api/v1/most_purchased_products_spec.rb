require 'swagger_helper'

RSpec.describe 'Most Purchased Products API', type: :request do
  path '/api/v1/stats/most_purchased_products' do
    get 'Returns most purchased products by category' do
      tags 'Statistics'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response '200', 'products returned' do
        let(:admin_user) { AdminUser.create(email: 'admin@example.com', password: 'password') }
        let(:Authorization) do
          token = JsonWebToken.encode(admin_user_id: admin_user.id)
          "Bearer #{token}"
        end

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalidtoken' }
        run_test!
      end
    end
  end
end
