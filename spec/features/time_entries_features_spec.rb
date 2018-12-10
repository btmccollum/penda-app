require 'rails_helper'

describe 'Feature Test: Dashboard', :type => :feature do
    before do 
        create_client_user
        create_business_user
        project_one = Project.create(title: "Project one", client_id: 1)
        project_two = Project.create(title: "Project two", client_id: 1, business_id: 2)
        time_entry_one = TimeEntry.create()

        visit '/login'
        log_in_client
        @client = Client.first
        @project = Project.first
    end

    # a user (no business partner) or a business user should be able to add a time entry
    it 'allows an authorized user to create a time entry' do
        visit '/dashboard'
        click_link('Project one')
        expect(current_path).to eq('/projects/1')

        click_button('Add New Entry')
        expect(current_path).to eq('/projects/1/time_entries/new')
        fill_in('time_entry[title]', with: 'time entry test')
        fill_in('time_entry[content]', with: 'test description')
        click_button("End Time")

        expect(@project.time_entries.last.id).to eq(1)
        visit '/projects/1'
        expect(page).to have_content("time entry test")
    end

    # a client should not be able to add entries when working with a business on a project
    it 'does not allow an unauthroized user to create a time entry' do 
        visit '/projects/2'
        expect(page).to have_no_content('Add New Entry')
    end
end