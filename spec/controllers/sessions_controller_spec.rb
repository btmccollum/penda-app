require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:each) do
    User.destroy_all
  end

  let(:user) {User.create(username: "testaccount", email: "dud@tester.com", password: "123", password_confirmation: "123", first_name: "Dud", last_name: "Tester", type: "Client", uid: "12345678", provider: "facebook")}

  describe 'get create' do
    it 'finds user if it exists and logs the user in' do
      auth = {
        :provider => 'facebook',
        :uid => user.uid,
        :info => {
          :email => 'dud@tester.com',
          :name => "Dud Tester"
        }
      }
      auth = ActiveSupport::HashWithIndifferentAccess.new(auth)
      @request.env['omniauth.auth'] = auth
      get :create
      expect(@request.session[:user_id]).to eq(user.id)
    end

    it 'creates a user if it doesnt exist in the db' do
      auth = {
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :email => 'shotester@test.com',
          :name => 'Sho Tester'
        }
      }
      auth = ActiveSupport::HashWithIndifferentAccess.new(auth)
      @request.env['omniauth.auth'] = auth
      get :create
      expect(@request.session[:user_id]).to eq(1)
    end

    it "create the user correctly" do
      name = 'Dud Tester'
      first_name = 'Dud'
      last_name = 'Tester'

      auth = {
        :provider => 'facebook',
        :uid => '1234567',
        :info => {
          :email => 'dudtester@test.com',
          :name => name
        }
      }
      auth = ActiveSupport::HashWithIndifferentAccess.new(auth)
      @request.env['omniauth.auth'] = auth
      get :create
      create_user = User.first
      expect(create_user.first_name).to eq(first_name)
    end
  end
end
