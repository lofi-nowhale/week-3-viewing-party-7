require 'rails_helper'

RSpec.describe "User can log in" do
  describe "happy path" do
    it "can log in a user with their proper credentials" do
      user =  User.create(name: 'User One', email: 'notunique@example.com', password: 'hipassword123', password_confirmation: 'hipassword123')
      visit root_path

      expect(page).to have_button("Log In") 
      click_button "Log In"

      expect(current_path).to eq("/login")

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_button "Submit"
      
      expect(current_path).to eq(user_path(user))

      expect(page).to have_content("#{user.name}'s Dashboard")
    end
  end

  describe "sad path" do
    it "can flash an error if the wrong credentials are input to the form" do
      user =  User.create(name: 'User One', email: 'notunique@example.com', password: 'hipassword123', password_confirmation: 'hipassword123')

      visit root_path

      expect(page).to have_button("Log In") 

      click_button "Log In"

      fill_in :email, with: user.email
      fill_in :password, with: 'fakepassword'

      click_button "Submit"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Can't log-in, incorrect credentials. Please check your credentials and try again")
    end
  end
end