class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
	  #Redirect to root url with success message if registered, otherwise render new
    if @user.save!
      @user.send_confirmation
      redirect_to root_url, notice: "User Registered successfully"
    else
      render 'new'
    end
  end

  def account_confirmation
    @user = User.find_by_password_reset_token(params[:token])
    if(@user)
      @user.update_column(:email_confirmed, true)
      @user.update_column(:password_reset_token, nil)
      redirect_to new_session_url, :notice => "Account confirmed"
    else
      redirect_to new_session_url, :notice => "Account could not be confirmed"
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name,:email,:phone,:password,:password_confirmation)
    end
end
