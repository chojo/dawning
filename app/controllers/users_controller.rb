class UsersController < ApplicationController
  public_page only: [:index, :show, :new, :create, :activate]

  def index
    navigation :user_ranking
    @users = User.active.asc(:created_at).page(params[:page])
  end

  def show
    navigation :account
    @user = User.find params[:id]
  end

  def new
    navigation :register
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      redirect_to root_path, :notice => "Successfully registered as #{@user.username}. Check your email to activate your account."
    else
      render :new
    end
  end

  def edit
    navigation :account
    @user = User.find params[:id]
    authorize! :update, @user
  end

  def update
    @user = User.find params[:id]
    authorize! :update, @user
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user), :notice => "User has been updated"
    else
      render :edit, :error => "Updating user failed"
    end
  end

  def destroy
    @user = User.find params[:id]
    authorize! :destroy, @user
    @user.destroy
    redirect_to users_path, :notice => "User #{@user.username} has been deleted"
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      auto_login(@user)
      redirect_to edit_user_path(@user), :notice => "Welcome #{@user.username}! Your account has been activated."
    else
      not_authenticated
    end
  end

end
