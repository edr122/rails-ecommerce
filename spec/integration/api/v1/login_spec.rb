require 'swagger_helper'

RSpec.describe 'Login API', type: :request do
  path '/api/v1/login' do
    post 'Authenticate admin and return JWT token' do
      tags 'Authentication'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '200', 'token returned' do
        let(:admin_user) { AdminUser.create(email: 'admin@example.com', password: 'password') }
        let(:credentials) { { email: admin_user.email, password: 'password' } }

        before do
          post '/api/v1/login', params: credentials.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        end

        it 'returns a JWT token' do
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to have_key('token')
        end
      end

      response '401', 'unauthorized' do
        let(:credentials) { { email: 'bad@example.com', password: 'wrong' } }

        before do
          post '/api/v1/login', params: credentials.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }
        end

        it 'returns unauthorized error' do
          expect(response).to have_http_status(401)
          expect(JSON.parse(response.body)).to have_key('error')
        end
      end
    end
  end
end