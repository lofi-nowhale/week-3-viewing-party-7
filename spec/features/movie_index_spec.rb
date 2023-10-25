require 'rails_helper'

RSpec.describe 'Movies Index Page' do
  before do 
    @user1 = User.create(name: "User One", email: "user1@test.com", password: 'password123', password_confirmation: 'password123')
    i = 1
    20.times do 
      Movie.create(title: "Movie #{i} Title", rating: rand(1..10), description: "This is a description about Movie #{i}")
      i+=1
    end 
    
  end 

  it 'shows all movies' do 
    visit root_path

    click_button "Log In"

    fill_in :email, with: 'user1@test.com'
    fill_in :password, with: 'password123'
    click_button "Submit"

    expect(current_path).to eq("/users/#{@user1.id}") 

    expect(page).to have_button("Find Top Rated Movies")

    click_button "Find Top Rated Movies"

    expect(current_path).to eq("/users/#{@user1.id}/movies")

    expect(page).to have_content("Top Rated Movies")

    Movie.all.each do |movie|
      within("#movie-#{movie.id}") do 
        expect(page).to have_link(movie.title)
        expect(page).to have_content("Rating: #{movie.rating}/10")
      end 
    end 
  end 
end