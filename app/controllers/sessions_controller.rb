class SessionsController < ApplicationController
  def new
  end
  
  def create
	  #Call authenticate_user method
    user = User.authenticate_user(params[:email], params[:password])
    
	  #If user is authenticated store user.id in a session variable and redirect, Otherwise display flash message and render 'new'
    if user
      session[:user] = user.id
      redirect_to root_url
    else
      flash.now.alert = "Invalid Email or Password"
      render 'new'
    end
  end
  
  def destroy
    session[:user] = nil
    redirect_to root_url, notice: "Signed out successfully"
  end
end
