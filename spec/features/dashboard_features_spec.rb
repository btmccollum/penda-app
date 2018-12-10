require 'rails_helper'

describe 'Feature Test: Dashboard', :type => :feature do
    before do 
        create_client_user
        project_one = Project.create(title: "Project one", client_id: 1)
        project_two = Project.create(title: "Project two", client_id: 1)
        project_three = Project.create(title: "Project three", client_id: 1, status: "completed")

        visit '/login'
        log_in_client
    end
    
    it 'shows a list of the users projects upon logging in' do
        visit '/dashboard'

        expect(page).to have_content('Project one')
        expect(page).to have_content('Project two')
        expect(page).to have_content('Project three')

        click_link("Show All")
        expect(page).to have_content('Project one')
        expect(page).to have_content('Project two')
        expect(page).to have_content('Project three')
    end

    it 'only shows active projects when a user clicks active' do
        visit '/dashboard'
        click_link("Active")

        expect(page).to have_content('Project one')
        expect(page).to have_content('Project two')
        expect(page).to have_no_content('Project three')
    end

    it 'only shows active projects when a user clicks active' do
        visit '/dashboard'
        click_link("Completed")

        expect(page).to have_no_content('Project one')
        expect(page).to have_no_content('Project two')
        expect(page).to have_content('Project three')
    end
end

