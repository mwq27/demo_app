class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    
    if user.nil?
      #create an error message
      flash.now[:error] = "Invalid email/password combination" #use flash.now when just rendering a page, use flash when redirecting
      @title = "Sign in"
      render 'new'
    else
      #sign the user in
      sign_in user
      redirect_back_or user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
