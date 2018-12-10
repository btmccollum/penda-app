require 'rails_helper'

describe 'Feature Test: Projects', :type => :feature do
    it 'successfully access form when logged in as a business user' do
        visit '/businesses/new'
        expect(current_path).to eq('/businesses/new')

        business_signup
        expect(current_path).to eq('/dashboard')

        visit '/projects/new'
        expect(page).to have_content('Create a New Project')
      end

    it 'successfully access form when logged in as a client user' do
        visit '/clients/new'
        expect(current_path).to eq('/clients/new')

        client_signup
        expect(current_path).to eq('/dashboard')

        visit '/projects/new'
        expect(page).to have_content('Create a New Project')
    end

    it 'does not allow unauthorized users to access the form' do 
        visit '/projects/new'
        expect(current_path).to eq('/login')
        expect(page).to have_content('Please log in.')
    end

    it 'allows a business user to create a new project and a new client' do
        create_business_user
        create_client_user

        visit '/sessions/new' 

        business_login
        expect(current_path).to eq('/dashboard')

        visit '/projects/new'
        fill_in('project[title]', with: 'Form Test Project')
        fill_in('project[client_attributes][first_name]', with: 'John')
        fill_in('project[client_attributes][last_name]', with: 'Smith')
        fill_in('project[client_attributes][email]', with: 'test@test.com')
        click_button('Submit')

        expect(Project.last.id).to eq(1)
        expect(Client.last.email).to eq('test@test.com')
        expect(current_path).to eq('/projects/1')
        expect(page).to have_content("Form Test Project")
    end
    
end