RSpec.describe Api::AppointmentsController do

  describe "#index" do
    it "returns json data" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET /appointments", type: :request do
    before do
      5.times do
        FactoryBot.create(:appointment)
      end
    end

    it 'returns all appointments' do
      get '/api/appointments'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(5)
    end

    it 'returns subset of appointments due to past params: past' do
      get '/api/appointments', params: {past: 1}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(5)
    end

    it 'returns subset of appointments due to past params: future' do
      get '/api/appointments', params: {past: 0}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(0)
    end

    it 'returns subset of appointments due to pagination: length only' do
      get '/api/appointments', params: {length: 4}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(4)
    end

    it 'returns subset of appointments due to pagination: length and page' do
      get '/api/appointments', params: {length: 4, page: 2}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

end
