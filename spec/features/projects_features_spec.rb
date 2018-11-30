require 'rails_helper'

describe 'Feature Test: Projects', :type => :feature do
    it 'successfully access creation form when logged in as a business user' do
        visit '/businesses/new'
        expect(current_path).to eq('/businesses/new')

        business_signup
        expect(current_path).to eq('/dashboard')

        visit '/projects/new'
        expect(page).to have_content("Create a New Project")
      end

    it 'does not allow a client user to access the form' do 
        visit '/clients/new'
        expect(current_path).to eq('/clients/new')

        client_signup
        expect(current_path).to eq('/dashboard')

        visit '/projects/new'
        expect(current_path).to eq('/dashboard')
        expect(page).to have_content("Unauthorized Access.")
    end

    it 'does not allow a user to access if not signed in' do
        visit '/projects/new'
        expect(current_path).to eq('/')
        expect(page).to have_content("Unauthorized Access.")
    end
end