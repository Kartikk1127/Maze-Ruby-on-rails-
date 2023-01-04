class ArticlesController < ApplicationController

  add_flash_types :info, :error, :warning


  def index
    @articles = Article.all
    @articles1 = Article.new
    @users = User.all
  end



  def show
    @article = Article.find(params[:id])
    # @articles1 = Article.new
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    # binding.pry

    if @article.save
      flash[:success] = "You have created your post successfully"
      redirect_to root_path
    else
      # puts @article.errors
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
    flash[:success] = "You have edited your post successfully"
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      flash[:success] = "You have updated your post successfully"
      redirect_to root_path
    else
      flash[:error] = "Post could not be updated"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:success] = "You have deleted the post successfully"

    redirect_to root_path, status: :see_other
  end

  private
    def article_params
      params.require(:article).permit(:user_id, :title, :body, :status)
    end
end
