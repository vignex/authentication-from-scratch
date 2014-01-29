class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
	#Redirect to root url with success message if registered, otherwise render new
    if @user.save!
      redirect_to root_url, notice: "User Registered successfully"
    else
      render 'new'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name,:email,:phone,:password,:password_confirmation)
    end
end
