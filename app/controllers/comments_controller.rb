class CommentsController < ApplicationController
    def create
      @article = Article.find(params[:article_id])
      # @comment.user_id = current_user.id
      @comment = @article.comments.create(comment_params.merge(user_id: current_user.id))

      redirect_to root_path(@article)
    end

    def edit
      @comment = Comment.find(params[:id])
    end

    def destroy
      # @article = Article.find(params[:id])
      # @comment=@article.comments.find(comment_params)
      @commentt = Comment.find(params[:id])
      @commentt.destroy
  
      redirect_to root_path, status: :see_other
    end

    def update
      @commentt = Comment.find(params[:id])
      @commentt.update(comment_params)
    end

    def new
      @article = Article.new(params[:article])
    end
  
  
    private
      def comment_params
        params.require(:comment).permit(:user_id, :commenter, :body, :status)
      end
  end
  