class UsersController < ApplicationController
before_filter :authenticate, :only => [:index, :edit, :update] # so users cant edit info while not signed in
before_filter :correct_user, :only => [:edit, :update]
before_filter :admin_user,    :only => :destroy
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to your new profile"
      redirect_to @user  #redirects to the user_path
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    #@user = User.find(params[:id])#dont need because of correct_user already defining @user
    @title = "Edit User"
  end
  
  def update
   # @user = User.find(params[:id]) #dont need because of correct_user already defining @user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User desctroyed"
    redirect_to users_path
  end
  
  
  private 
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
