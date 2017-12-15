class SessionsController < ApplicationController

  def new
    @user = User.new
    redirect_to users_path if logged_in?
  end

  #login through social media or signup form
  def create
    if auth
      @user = User.set_user_from_omniauth(auth['uid'])
      log_user_in
      redirect_to artists_path(@user), flash: {success: "You're logged in through Facebook!"} #user_path(@user)
    else
      #find user by email
      @user = User.find_by(email: params[:user][:email])
      if @user && @user.authenticate(params[:user][:password])
        log_user_in
        redirect_to artists_path, flash: {success: "You're logged in!"}  #user_path(@user)
      else
        render 'sessions/new', flash: {success: "Invalid email/password combination!"}
      end
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

    def auth
      request.env['omniauth.auth']
    end

end
