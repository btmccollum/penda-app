require 'rails_helper'

describe 'Feature Test: Comments', :type => :feature do
    before do 
        create_client_user
        create_business_user
        project_one = Project.create(title: "Project one", client_id: 1)
        project_two = Project.create(title: "Project two", client_id: 1, business_id: 2)
        @project = project_two

        visit '/login'
        log_in_client
        @client = Client.first
        @project = Project.first
    end

    it 'allows an authorized user to add a comment' do 
        visit '/projects/1'
        fill_in("comment[content]", with: "Testing comment")
        click_button("Submit")
        expect(Comment.last.id).to eq(1)
        expect(page).to have_content("Testing comment")
    end

    it 'allows a comment owner to see the option to delete' do
        visit '/projects/1'
        fill_in("comment[content]", with: "Testing comment")
        click_button("Submit")
        expect(page).to have_link("X")
    end

    it 'does not allow a non-comment owner to see the delete option for another users comment' do
        visit '/projects/2'
        fill_in("comment[content]", with: "Testing comment")
        click_button("Submit")
        click_link("Log Out")
        visit '/login'
        business_login

        visit '/projects/2'
        expect(page).to have_no_link("X")
    end

    it 'the view all comments page includes recently added comments' do 
        visit '/projects/1'
        fill_in("comment[content]", with: "Testing comment")
        click_button("Submit")
        click_button("All Comments")
        expect(page).to have_content("Testing comment")
    end
end