class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
      # if @comment.save!

        format.js { render :index }
      else
        format.js { render :form }
        # format.html { redirect_to article_path(@article), notice: '投稿できませんでした...' }
      end
    end
  end

  def edit

    @comment = Comment.find(params[:id])

  end

  def update
    @comment = Comment.find(params[:id])
    @article = @comment.article

    if @comment.update(comment_params)
      redirect_to article_path(@article)
    else

      flash[:danger] = @comment.errors.full_messages
      redirect_to edit_comment_path(@comment)
    end
    # redirect_to article_path(@article) if @comment.update(comment_params)
  end

  def destroy
    
    @comment = Comment.find(params[:id])
    @article = @comment.article
    if @comment.destroy
      respond_to do |format|

        #form再表示用に、@commentを再セット
        @comment = @article.comments.build
        # @comment = @article.comments.build

        format.js { render :index }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:article_id, :content, :article_id)
  end
end
