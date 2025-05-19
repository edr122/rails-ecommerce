require 'swagger_helper'

RSpec.describe 'Top Earning Products API', type: :request do
  path '/api/v1/stats/top_earning_products' do
    get 'Returns top 3 earning products per category' do
      tags 'Statistics'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response '200', 'top products returned' do
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