RSpec.describe Api::AppointmentsController do

  describe "#index" do
    it "returns json data" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "API appointments", type: :request do
    describe "POST /appointments" do
      it 'create new appointment' do
        expect{
          post '/api/appointments', params: {
            "patient": {
              "name": FactoryBot.create(:patient).name
            },
            "doctor": {
              "id": FactoryBot.create(:doctor).id
            },
            "start_time": "2037-02-12T00:00:00.000Z",
            "duration_in_minutes": 50
          }
        }.to change {Appointment.count}.from(0).to(1)
        expect(response).to have_http_status(:created)
      end
    end

    describe "GET /appointments" do
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
end
