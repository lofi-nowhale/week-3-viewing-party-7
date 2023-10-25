require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    user1 = User.create(name: "User One", email: "user1@test.com", password: '123password', password_confirmation: '123password')
    user2 = User.create(name: "User Two", email: "user2@test.com", password: 'mypassword123', password_confirmation: 'mypassword123')
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do 
    visit '/'

    click_button "Create New User" 

    fill_in :user_name, with: "user 1"
    fill_in :user_email, with: "user@test1.com"
    fill_in :user_password, with: "mypassword"
    fill_in :user_password_confirmation, with: "mypassword"

    click_button "Create New User"

    expect(current_path).to eq user_path(User.last)

    click_link "Home"

    user1 = User.create(name: "User One", email: "user1@test.com")
    user2 = User.create(name: "User Two", email: "user2@test.com")

    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.email)
    end     
  end 

  it 'shows a log out button if the user is logged in' do
    visit '/'

    click_button "Create New User" 

    fill_in :user_name, with: "user 1"
    fill_in :user_email, with: "user@test1.com"
    fill_in :user_password, with: "mypassword"
    fill_in :user_password_confirmation, with: "mypassword"

    click_button "Create New User"

    expect(current_path).to eq user_path(User.last)

    click_link "Home"

    expect(page).to_not have_button("Create New User")
    expect(page).to_not have_button("Log In")
    expect(page).to have_button("Log Out")
  end

  it "doesn't show the existing users section if user is visiting as a guest" do
    visit root_path

    expect(page).to_not have_content("Existing Users")
  end
end
