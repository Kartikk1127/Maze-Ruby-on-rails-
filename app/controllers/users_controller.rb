# require 'csv'
class UsersController < ApplicationController

  def index
    @users = User.all
    @articles=Article.all

    respond_to do |format|
      # format.xlsx
      format.xlsx do
        send_data User.to_indexx
      end
      format.csv do
        send_data User.to_index, filename: Date.today.to_s, content_type: "text/csv"
      end
    end
  end

  def downloads
    @users = User.all
    # @articles=Article.all
    respond_to do |format|
      format.html
      # format.xlsx
      format.xlsx do
              send_data User.to_downloads
            end
      format.csv do
        send_data User.to_post, filename: Date.today.to_s, content_type: "text/csv"
      end
    end
  end

  def post
    @users = User.all
    @articles=Article.all
    respond_to do |format|
      format.html
      # format.xlsx
      format.xlsx do
        send_data User.to_posts
      end
      format.csv do
        send_data User.to_post, filename: Date.today.to_s, content_type: "text/csv"
      end
    end
  end

  def new

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path
      flash[:notice] = "User has been created"   #there you are!!!
    else
      # puts @article.errors
      # flash[:alert] = "Something went wrong ..."   # ah! again, there you are!!!
      redirect_to registration_path, info: "Invalid email or password"
    end
  end

  def ban
    @user = User.find(params[:id])
    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    redirect_to users_path
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.update(user_params)
      redirect_to users_path, notice: "User was successfully updated."
    else
      render :edit
    end
  end


  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password)
  end
end
