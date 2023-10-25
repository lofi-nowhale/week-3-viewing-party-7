class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    if current_user
      @user = User.find(params[:id])
    else 
      flash[:error] = "Please log in or register for an account to access your dashboard"
      redirect_to root_path
    end
  
  end 

  def create 
    user = user_params
    user[:email] = user[:email].downcase
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user)
    else  
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end 
  end 

  def login_form
  end

  def login_user
    @user = User.find_by(email: params[:email])
    if @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to user_path(@user)
    else 
      flash[:error] = "Can't log-in, incorrect credentials. Please check your credentials and try again"
      render :login_form
    end

  end

  def logout
    reset_session
    flash[:notice] = "Bye"
    redirect_to '/'
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 
end 