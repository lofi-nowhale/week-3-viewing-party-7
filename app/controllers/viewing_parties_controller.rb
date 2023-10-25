class ViewingPartiesController < ApplicationController 
  def new

    if current_user
      @user = User.find(params[:user_id])
      @movie = Movie.find(params[:movie_id])
    else 
      flash[:error] = "Please log in or register for an account to create a viewing party."
      redirect_to "/users/#{params[:user_id]}/movies/#{params[:movie_id]}"
    end
  end 
  
  def create 
    user = User.find(params[:user_id])
    user.viewing_parties.create(viewing_party_params)
    redirect_to "/users/#{params[:user_id]}"
  end 

  private 

  def viewing_party_params 
    params.permit(:movie_id, :duration, :date, :time)
  end 
end 