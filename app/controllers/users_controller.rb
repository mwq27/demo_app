class UsersController < ApplicationController
before_filter :authenticate, :except => [:show, :new, :create] # so users cant edit info while not signed in
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
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(paras[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
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
    @user = User.find(params[:id])  
      if current_user.admin? && @user != current_user
        @user.destroy 
    flash[:success] = "User destroyed"
    redirect_to users_path
    else
      flash[:notice]= "Can not delete yourself"
      redirect_to(user_path)
    end
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  
  private 
   
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
