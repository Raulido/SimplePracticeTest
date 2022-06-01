RSpec.describe Api::DoctorsController do

    describe "#index" do
      it "returns json data" do
        get :index
        expect(response.status).to eq(200)
      end
    end
  
    describe "GET /doctors", type: :request do
      before do
        5.times do
          FactoryBot.create(:doctor)
        end
      end
  
      it 'returns all docotors with no appointments' do
        get '/api/doctors'
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  
end